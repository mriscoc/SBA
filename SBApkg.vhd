--------------------------------------------------------------------------------
--
-- SBA Package
--
-- version 5.5 2019/08/04
--
-- General functions and procedures definitions
-- for SBA v1.2
--
-- Author:
-- (c) Miguel A. Risco-Castillo
-- sba webpage: http://sba.accesus.com
--
--------------------------------------------------------------------------------
-- For License and copyright information refer to the file:
-- https://github.com/mriscoc/SBA/blob/master/SBAlicense.md
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
  function MAXIMUM(a:unsigned;b:unsigned) return unsigned;
  function MINIMUM(a:unsigned;b:unsigned) return unsigned;
  function MAXIMUM(a:signed;b:signed) return signed;
  function MINIMUM(a:signed;b:signed) return signed;

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

  function MAXIMUM(a:unsigned;b:unsigned) return unsigned is
  begin
    if a>b then
      return a;
    else
      return b;
    end if;
  end;

  function MINIMUM(a:unsigned;b:unsigned) return unsigned is
  begin
    if a<b then
      return a;
    else
      return b;
    end if;
  end;

  function MAXIMUM(a:signed;b:signed) return signed is
  begin
    if a>b then
      return a;
    else
      return b;
    end if;
  end;

    function MINIMUM(a:signed;b:signed) return signed is
  begin
    if a<b then
      return a;
    else
      return b;
    end if;
  end;

end;

