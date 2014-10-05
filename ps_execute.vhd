--
-- execution unit. only a subset of instructions are supported in this
-- model, specifically add, sub, lw, sw, beq, and, or
--

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity execute is
port(
--
-- inputs
-- 
     PC4 : in std_logic_vector(31 downto 0);
     register_rs, register_rt :in std_logic_vector (31 downto 0);
     Sign_extend :in std_logic_vector(31 downto 0);
     ALUOp: in std_logic_vector(1 downto 0);
     ALUSrc, RegDst : in std_logic;
     wreg_rd, wreg_rt : in std_logic_vector(4 downto 0);

-- outputs
--
     alu_result, Branch_PC :out std_logic_vector(31 downto 0);
     wreg_address : out std_logic_vector(4 downto 0);
     multiHi : out std_logic_vector(31 downto 0);
     multiLo: out std_logic_vector(31 downto 0);
     multi: out std_logic;
     zero: out std_logic);    
     end execute;


architecture behavioral of execute is 
SIGNAL Ainput, Binput, slt	: STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
signal ALU_Internal : std_logic_vector (31 downto 0);
Signal Function_opcode : std_logic_vector (5 downto 0);
signal multiout : std_logic_vector( 63 downto 0);
signal multisig: std_logic;
SIGNAL ALU_ctl	: STD_LOGIC_VECTOR( 2 DOWNTO 0 );

BEGIN
   	-----------------------
	--forwarding control---
	-----------------------
	
	-- Register rs
	Ainput <=		mem_Writedata WHEN (forward_a = "10") ELSE  -- EX Hazard #1 or Hazard Case  (i.)
					wb_Writedata WHEN (forward_b = "01") ELSE   -- Mem Hazard #2 or Hazard Case (iv.)
					register_rs;
					
	-- Register rt
	rt_sel <=		wb_Writedata WHEN (forward_a = "01") ELSE   -- Mem Hazard #1 or Hazard Case (iii.)
					mem_Writedata WHEN (forward_b = "10") ELSE  -- EX Hazard #2 or Hazard Case (ii.)
					register_rt;
	
	ex_mem_register_rt <= rt_sel;
	
	-- ALU input mux
	Binput <= register_rt WHEN ( ALUSrc = '0' ) else
	          Sign_extend(31 downto 0) when ALUSrc = '1' else
	         X"BBBBBBBB";
	         
	 Branch_PC <= PC4 + (Sign_extend(29 downto 0) & "00");
	 
	 -- Get the function field. This will be the least significant
	 -- 6 bits of  the sign extended offset
	 
	 Function_opcode <= Sign_extend(5 downto 0);
	         
		-- Generate ALU control bits
		
	ALU_ctl( 0 ) <= ( Function_opcode( 0 ) OR Function_opcode( 3 ) ) AND ALUOp(1 );
	ALU_ctl( 1 ) <= ( NOT Function_opcode( 2 ) ) OR (NOT ALUOp( 1 ) );
	ALU_ctl( 2 ) <= ( Function_opcode( 1 ) AND ALUOp( 1 )) OR ALUOp( 0 );
		
		-- Generate Zero Flag
	Zero <= '1' WHEN ( ALU_internal = X"00000000"  )
		         ELSE '0';    	 
		         
-- implement the RegDst mux
--
multi	 <=	multisig;
multisig <=	'1' WHEN (ALU_ctl = "011")
				Else '0';
				
wreg_address <= wreg_rd WHEN RegDst = '1' ELSE 
				wreg_rt;
		         			   
  ALU_result <= ALU_internal;					
	multiHi <=	multiout(63 downto 32);
	multiLo <=	multiout(31 downto 0);
	slt		<=	X"00000001" WHEN (Ainput < Binput) ELSE 
				X"00000000";
	
PROCESS ( ALU_ctl, Ainput, Binput )
	BEGIN
					-- Select ALU operation
 	CASE ALU_ctl IS
						-- ALU performs ALUresult = A_input AND B_input
		WHEN "000" 	=>	ALU_internal 	<= Ainput AND Binput; multiout <= X"0000000000000000"; 
						-- ALU performs ALUresult = A_input OR B_input
     	WHEN "001" 	=>	ALU_internal 	<= Ainput OR Binput; multiout <= X"0000000000000000";
						-- ALU performs ALUresult = A_input + B_input
	 	WHEN "010" 	=>	ALU_internal 	<= Ainput + Binput;
						multiout <= X"0000000000000000";
						
						-- ALU performs beq/mult
 	 	WHEN "011" 	=>	ALU_internal 	<=  Ainput - Binput;
						multiout <= Ainput*Binput;
						
		WHEN "100" 	=>	ALU_internal 	<= X"00000000";
						multiout <= X"0000000000000000";
		  
 	 	WHEN "101" 	=>	ALU_internal <= X"00000000";
						multiout <= X"0000000000000000";
 	 	               
						-- ALU performs ALUresult = A_input -B_input
 	 	WHEN "110" 	=>	ALU_internal 	<= (Ainput - Binput); multiout <= X"0000000000000000";
						-- ALU performs SLT
  	 	WHEN "111" 	=>	ALU_internal 	<= slt; multiout <= X"0000000000000000";
 	 	WHEN OTHERS	=>	ALU_internal 	<= X"FFFFFFFF"; multiout <= X"0000000000000000";
  	END CASE;
  	
  END PROCESS;

end behavioral;



