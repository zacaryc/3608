Library IEEE;
use IEEE.std_logic_1164.all;

entity pipe_reg2 is
port (id_MemToReg, id_RegWrite, id_MemWrite, id_MemRead: in std_logic;       
      id_ALUSrc, id_RegDst, clk, reset, id_branch : in std_logic;
      id_ALUOp : in std_logic_vector(1 downto 0);
      id_PC4: in std_logic_vector(31 downto 0);
      id_register_rs, id_register_rt, id_sign_extend: in std_logic_vector(31 downto 0); 
      id_wreg_rd, id_wreg_rt : in std_logic_vector(4 downto 0);

      ex_MemToReg, ex_RegWrite, ex_MemWrite, ex_MemRead, ex_branch: out std_logic;
      ex_ALUSrc, ex_RegDst : out std_logic;  
      ex_ALUOp : out std_logic_vector(1 downto 0);
      ex_PC4: out std_logic_vector(31 downto 0);
      ex_register_rs, ex_register_rt, ex_sign_extend: out std_logic_vector(31 downto 0);  
      ex_wreg_rd, ex_wreg_rt : out std_logic_vector(4 downto 0));
end pipe_reg2;


architecture behavioral of pipe_reg2 is
begin
process
begin
wait until (rising_edge(clk));
if reset ='1' then 
	 ex_branch <= '0';
	 ex_MemToReg <= '0';
	 ex_RegWrite <= '0';
	 ex_MemWrite <= '0';
	 ex_MemRead <= '0';
	 ex_ALUSrc <= '0';
	 ex_RegDst <= '0';
     ex_ALUOp  <= "00";
	 ex_PC4 <= x"00000000";
	 ex_register_rs  <= x"00000000";
	 ex_register_rt  <=  x"00000000";
	 ex_sign_extend  <=  x"00000000";
	 ex_wreg_rd  <= "00000";
	 ex_wreg_rt  <= "00000";
else

	 ex_branch <= id_branch;
	 ex_MemToReg <= id_MemToReg;
	 ex_RegWrite <= id_RegWrite;
	 ex_MemWrite <= id_MemWrite;
	 ex_MemRead <= id_MemRead;
	 ex_ALUSrc <= id_ALUSrc;
	 ex_RegDst <= id_RegDst;
     ex_ALUOp  <= id_ALUOp;
	 ex_PC4 <= id_PC4;
	 ex_register_rs  <= id_register_rs;
	 ex_register_rt  <= id_register_rt;
	 ex_sign_extend <= id_sign_extend;
	 ex_wreg_rd  <= id_wreg_rd;
	 ex_wreg_rt  <= id_wreg_rt;

end if;
end process;
end behavioral;
