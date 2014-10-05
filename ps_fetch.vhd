--
-- Instruction fetch behavioral model. Instruction memory is
-- provided within this model. IF increments the PC,  
-- and writes the appropriate output signals. 

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Std_logic_arith.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


entity fetch is 
--

port(instruction  : out std_logic_vector(31 downto 0);
	  PC_out       : out std_logic_vector (31 downto 0);
	  Branch_PC    : in std_logic_vector(31 downto 0);
	  clock, reset, PCSource:  in std_logic);
end fetch;

architecture behavioral of fetch is 
TYPE INST_MEM IS ARRAY (0 to 35) of STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL iram : INST_MEM := (
       X"00028020",
X"00018820",
X"00019820",
X"0121502a",
X"00000000",
X"00000000",
X"1141000a",
X"00000000",
X"00000000",
X"00000000",
X"0211402a",
X"00000000",
X"00000000",
X"1100000b",
X"00000000",
X"00000000",
X"00000000",
X"02629820",
X"00000000",
X"00000000",
X"00132020",
X"1000ffea",
X"00000000",
X"00000000",
X"00000000",
X"02619820",
X"00000000",
X"00000000",
X"02710019",
X"00000000",
X"00000000",
X"001e8820",
X"001f4820",
X"1000ffe1",
X"00000000",
X"00000000"
 
                     
   );
   
   SIGNAL PC, Next_PC : STD_LOGIC_VECTOR( 31 DOWNTO 0 );

BEGIN 						
-- access instruction pointed to by current PC
-- and increment PC by 4. This is combinational
		             
Instruction <=  iram(CONV_INTEGER(PC(4 downto 2)));
PC_out<= (PC + 4);			
   
-- compute value of next PC

Next_PC <=  (PC + 4)    when PCSource = '0' else
            Branch_PC    when PCSource = '1' else
            X"CCCCCCCC";
			   
-- update the PC on the next clock			   
	PROCESS
		BEGIN
			WAIT UNTIL (rising_edge(clock));
			IF (reset = '1') THEN
				PC<= X"00000000" ;
			ELSE 
				PC <= Next_PC;    -- cannot read/write a port hence need to duplicate info
			 end if; 
			 
	END PROCESS; 
   
   end behavioral;


	
