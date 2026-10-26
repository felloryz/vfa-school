#  ------------------- TODO ----------------------
# | Настройте вывод проводов тестируемого дизайна |
# | на временную диаграмму.                       |
#  ------------------- TODO ----------------------

add wave -position insertpoint  \
sim:/tb_irq_ctrl/dut/reqs_i \
sim:/tb_irq_ctrl/dut/mode_i \
sim:/tb_irq_ctrl/dut/reqs_o

run -a;
