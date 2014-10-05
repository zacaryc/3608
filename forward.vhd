--
-- fowarding unit.
--

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity forward is
port(

	mem_RegisterRd, wb_RegisterRd, id_RegisterRs, id_RegisterRt: in std_logic_vector(4 downto 0);
	mem_regWrite, wb_regWrite: in std_logic;
	
	forwardA, forwardB: out std_logic_vector(1 downto 0);
);
end forward;

architecture behavioural of forward is 
	
signal ex_HazardA, ex_HazardB, mem_HazardA, mem_HazardB: std_logic; 

	begin
	-- Execution Hazards
	 ex_HazardA <= mem_RegWrite WHEN((mem_RegisterRd /= 0) AND (mem_RegisterRd = id_RegisterRs)) ELSE '0'; 
	 ex_HazardB <= mem_RegWrite WHEN((mem_RegisterRd /= 0) AND (mem_RegisterRd = id_RegisterRt)) ELSE '0'; 
	
	-- Memory Hazards
	mem_HazardA <= wb_RegWrite WHEN ((wb_RegisterRd /= 0) AND (wb_RegisterRd = id_RegisterRs) AND NOT((mem_RegWrite='1')AND(mem_RegisterRd /= 0) AND (mem_RegisterRd = id_RegisterRs))) ELSE '0'; 
	 
	mem_HazardB <= wb_RegWrite WHEN((wb_RegisterRd/= 0) AND (wb_RegisterRd = id_RegisterRt) AND NOT((mem_RegWrite='1') AND (mem_RegisterRd /= 0) AND (mem_RegisterRd = id_RegisterRt))) ELSE '0'; 
	 
	 
	-- Set forwardA and forwardB to boolean output of above functions
	 forwardA <= 	"10" WHEN (ex_HazardA  = '1') ELSE 
			"01" WHEN (mem_HazardA = '1') ELSE 
			"00"; 
	 
	 forwardB <= 	"10" WHEN (ex_HazardB  = '1') ELSE 
			"01" WHEN (mem_HazardB = '1') ELSE 
			"00"; 
end behavioural;
