from itertools import product
filename = "prototype.circ"
prev_name = "reg1024"
circuit_name = "reg1024"

def rewrite_circuit(content):
    with open(filename, "r") as file:
        contents = file.readlines()

    start = contents.index(f'  <circuit name="{prev_name}">\n')
    end = contents.index(f'  </circuit>\n', start)
    circuit_start = f"""  <circuit name="{circuit_name}">
    <a name="circuit" val="{circuit_name}"/>
    <a name="clabel" val=""/>
    <a name="clabelup" val="east"/>
    <a name="clabelfont" val="SansSerif plain 12"/>\n"""
    circuit_end = "  </circuit>\n"
    start_x = 160
    start_y = 440
    step_x = 0
    step_y = 300
    contents = contents[:start] + [circuit_start] + content + [circuit_end] + contents[end+1:]

    with open(filename, "w") as file:
        file.writelines(contents)
