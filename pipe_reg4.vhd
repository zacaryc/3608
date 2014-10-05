Library IEEE;
use IEEE.std_logic_1164.all;

entity pipe_reg4 is
port (mem_MemToReg, mem_RegWrite, mem_multi : in std_logic;
      mem_memory_data, mem_alu_result,mem_multiHi,mem_multiLo : in std_logic_vector(31 downto 0);
      mem_wreg_addr: in std_logic_vector(4 downto 0);
      clk,reset : in std_logic;

      wb_MemToReg, wb_RegWrite, wb_multi: out std_logic;
      wb_memory_data, wb_alu_result,wb_multiHi, wb_multiLo: out std_logic_vector(31 downto 0);
      wb_wreg_addr: out std_logic_vector(4 downto 0));
end pipe_reg4;

architecture behavioral of pipe_reg4 is
begin
process
begin
wait until (rising_edge(clk));
if reset = '1'  then 
         wb_MemToReg <= '0';
	 wb_RegWrite <=  '0';
	 wb_memory_data <=  x"00000000";
	 wb_alu_result <=  x"00000000";
 	 wb_wreg_addr <= "00000";
 	 wb_multiHi <= x"00000000";
	 wb_multiLo <=x"00000000";
	 wb_multi <= '0';

else 

         wb_MemToReg <= mem_MemToReg;
	 wb_RegWrite <=  mem_RegWrite;
	 wb_memory_data <=  mem_memory_data;
	 wb_alu_result <=  mem_alu_result;
 	 wb_wreg_addr <= mem_wreg_addr;
 	  wb_multiHi <= mem_multiHi;
	 wb_multiLo <=mem_multiLo;
	 wb_multi <= mem_multi;
end if;
end process;
end behavioral;
