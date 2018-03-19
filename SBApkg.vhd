--------------------------------------------------------------------------------
--
-- SBA Package
--
-- version 5.3 2017/01/03
--
-- General functions and procedures definitions
-- for SBA v1.2
--
-- Author:
-- (c) Miguel A. Risco-Castillo
-- sba webpage: http://sba.accesus.com
--
-- Release Notes
--
-- v5.3 2017/01/03
-- revert v5.2, removing functions for signals
--
-- v5.2 2016/11/03
-- add inc and dec functions for signed, unsigned and integer signals arguments
--
-- v5.1 20151129
-- minor correction: add integer range disambiguation to udiv function to avoid
-- GHDL warning, release notes reposition in source file.
--
-- v5.0 20150528
-- added unsigned and integer division
--
-- v4.9 20121107
-- added Trailing function
--
-- v4.8 20120824
-- added random n bits vector and integer number generator functions.
--
-- v4.7 20120613
-- removed the stb function and type definitions
--
-- v4.6 20111125
-- minor change on function hex (resize of result)
--
-- v4.5 20110616
-- minor change on function stb

-- v4.4 20110411
-- added inc and dec procedures for integers
--
-- v4.3 20101118
-- added Greatest common divisor function
--
-- v4.2 20101019
-- change stb() function for Xilinx ISE compatibility
--
-- v4.1 20101019
-- add internal Data Type to unsigned
--
-- v4.0 20101009
-- Transfer config values to SBA_config package
-- added multiple conversion functions
--
-- v3.5 20100917
-- v3.0 20100812
-- v2.3 20091111
-- v2.2 20091024
-- v2.0 20091021
-- v1.2 20081101
--
--------------------------------------------------------------------------------
-- Copyright:
--
-- This code, modifications, derivate work or based upon, can not be used or
-- distributed without the complete credits on this header.
--
-- The copyright notices in the source code may not be removed or modified.
-- If you modify and/or distribute the code to any third party then you must not
-- veil the original author. It must always be clearly identifiable.
--
-- Although it is not required it would be a nice move to recognize my work by
-- adding a citation to the application's and/or research. If you use this
-- component for your research please include the appropriate credit of Author.
--
-- FOR COMMERCIAL PURPOSES REQUEST THE APPROPRIATE LICENSE FROM THE AUTHOR.
--
-- For non commercial purposes this version is released under the GNU/GLP license
-- http://www.gnu.org/licenses/gpl.html
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package SBApackage is

  function udiv(a:unsigned;b:unsigned) return unsigned;
  function sdiv(a:signed;b:signed) return signed;
  function trailing(slv:std_logic_vector;len:positive;value:std_logic) return std_logic_vector;
  function rndv(n:natural) return std_logic_vector;
  function rndi(n:integer) return integer;
  function chr2uns(chr: character) return unsigned;
  function chr2int(chr: character) return integer;
  function chr(uns: unsigned) return character;
  function chr(int: integer) return character;
  function hex2uns(hex: unsigned) return unsigned;
  function hex(uns: unsigned) return unsigned;
  function hex(int: integer) return integer;
  function hex(int: integer) return character;
  function int2str(int: integer) return string;
  function gcd(dat1,dat2:integer) return integer;  -- Greatest common divisor
  procedure clr(signal val: inout std_logic_vector);
  procedure clr(variable val:inout unsigned);
  procedure inc(signal val:inout std_logic_vector);
  procedure inc(variable val:inout unsigned);
  procedure inc(variable val:inout integer);
  procedure dec(signal val:inout std_logic_vector);
  procedure dec(variable val:inout unsigned);
  procedure dec(variable val:inout integer);

end SBApackage;

package body SBApackage is

  function sdiv(a:signed;b:signed) return signed is
  variable a1 : unsigned(a'length-1 downto 0);
  variable b1 : unsigned(b'length-1 downto 0);
  begin
    a1:= unsigned(abs(a(a'range)));
    b1:= unsigned(abs(b(b'range)));
    if (a<0 and b>=0) or (a>=0 and b<0) then
      return -signed(udiv(a1,b1));
    else
      return signed(udiv(a1,b1));
    end if;
  end;

  function  udiv  (a : unsigned; b : unsigned) return unsigned is
  variable a1 : unsigned(a'length-1 downto 0):=a;
  variable b1 : unsigned(b'length-1 downto 0):=b;
  variable p1 : unsigned(b'length downto 0):= (others => '0');
  variable i : integer:=0;
  begin
    for i in integer range 0 to b'length-1 loop
      p1(b'length-1 downto 1) := p1(b'length-2 downto 0);
      p1(0) := a1(a'length-1);
      a1(a'length-1 downto 1) := a1(a'length-2 downto 0);
      p1 := p1-b1;
      if(p1(b'length-1) ='1') then
        a1(0) :='0';
        p1 := p1+b1;
      else
        a1(0) :='1';
      end if;
    end loop;
  return a1;
  end udiv;

--
-- Destiny<=Trailing(Source, Destiny'length, '1/0/Z/X');  
-- 
  function trailing(slv:std_logic_vector;len:positive;value:std_logic) return std_logic_vector is
  variable s:integer;
  variable v:std_logic_vector(len-1 downto 0);
  begin
    s:=slv'length;
    if (len>s) then
      v:= slv & (len-(s+1) downto 0 => value);
    else
      v:= slv(slv'high downto s-len);
    end if;
    return v;
  end;

  function rndi(n:integer) return integer is
  variable R: real;
  variable S1, S2: positive := 69;
  begin
    uniform(S1, S2, R);
    Return integer(R*real(n+1));
  end;

  function rndv(n:natural) return std_logic_vector is
  begin
    return std_logic_vector(to_unsigned(rndi(2**n-1),n));
  end;

  function chr2uns(chr: character) return unsigned is
  begin
    return to_unsigned(character'pos(chr),8);
  end;

  function chr2int(chr: character) return integer is
  begin
    return character'pos(chr);
  end;

  function chr(uns: unsigned) return character is
  begin
    return character'val(to_integer(uns));
  end;

  function chr(int: integer) return character is
  begin
    return character'val(int);
  end;

  function hex2uns(hex: unsigned) return unsigned is
  variable ret:unsigned(hex'range);
  begin
    if (hex>=chr2uns('0')) and (hex<=chr2uns('9')) then
      ret:= hex - chr2uns('0');
    elsif (hex>=chr2uns('A')) and (hex<=chr2uns('F')) then
      ret:= hex - chr2uns('A') + 10;
    else
      ret:= (others=>'0');
    end if;
    return ret;
  end;

  function hex(uns: unsigned) return unsigned is
  variable ret:unsigned(uns'range);
  begin
    if (uns<=9) then
      ret:= uns + resize(chr2uns('0'),uns'length);
    elsif (uns>=10) and (uns<=15) then
      ret:= uns + resize(chr2uns('A'),uns'length) - 10;
    else
      ret:= resize(chr2uns('?'),uns'length);
    end if;
    return ret;     
  end;

  function hex(int: integer) return integer is
  variable ret:integer;
  begin
    if (int<=9) then
      ret:= int + chr2int('0');
    elsif (int>=10) and (int<=15) then
      ret:= int + chr2int('A') - 10;
    else
      ret:= chr2int('?');
    end if;
    return ret;     
  end;

  function hex(int: integer) return character is
  begin
    return chr(hex(int));
  end;  

-- convert integer to string using specified base
-- (adapted from Steve Vogwell's posting in comp.lang.vhdl)
  function int2str(int: integer) return string is
    variable temp:      string(1 to 10);
    variable num:       integer;
    variable abs_int:   integer;
    variable len:       integer := 1;
    variable power:     integer := 1;
    constant base : integer := 10;
  begin
    -- bug fix for negative numbers
    abs_int := abs(int);
    num     := abs_int;
    while num >= base loop                     -- Determine how many
      len := len + 1;                          -- characters required
      num := num / base;                       -- to represent the
    end loop ;                                 -- number.
    for i in len downto 1 loop                 -- Convert the number to
      temp(i) := hex(abs_int/power mod base);  -- a string starting
      power := power * base;                   -- with the right hand
    end loop ;                                 -- side.
    -- return result and add sign if required
    if int < 0 then
       return '-'& temp(1 to len);
     else
       return temp(1 to len);
    end if;
  end int2str;

-- Greatest common divisor
  function gcd(dat1,dat2:integer) return integer is
  variable tmp_X, tmp_Y: integer;
  begin
    tmp_X := dat1;
    tmp_Y := dat2;
    while (tmp_X/=tmp_Y) loop
      if (tmp_X/=tmp_Y) then
        if (tmp_X < tmp_Y) then
          tmp_Y := tmp_Y - tmp_X;
        else
          tmp_X := tmp_X - tmp_Y;
        end if;
      end if;
    end loop;
    return tmp_X;
  end;

  procedure clr(signal val:inout std_logic_vector) is
  begin
    val <= std_logic_vector(to_unsigned(0, val'length));
  end;

  procedure clr(variable val:inout unsigned) is
  begin
    val := to_unsigned(0,val'length);
  end;

  procedure inc(signal val:inout std_logic_vector) is
  begin
    val<= std_logic_vector(unsigned(val) + 1);
  end;

  procedure inc(variable val:inout unsigned) is
  begin
    val := val + 1;
  end;

  procedure inc(variable val:inout integer) is
  begin
    val := val + 1;
  end;

  procedure dec(signal val:inout std_logic_vector) is
  begin
    val<= std_logic_vector(unsigned(val) - 1);
  end;

  procedure dec(variable val:inout unsigned) is
  begin
    val := val - 1;
  end;

  procedure dec(variable val:inout integer) is
  begin
    val := val - 1;
  end;

end;

