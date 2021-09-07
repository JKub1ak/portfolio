Spis treści:

FOLDERY:
	modele/*	- modele uczone i używane w zadaniach
	out/*		- folder do zapisywania rysunków (domyślnie pusty)
	sieci/*		- folder programu 'sieci' do uczenia sieci neuronowych (domyślnie pusty)

PLIKI:
	init_sim.m		- plik inicjalizujący symulację
	init_proces.m 	- plik inicjalizujący proces
	step_proces.m 	- plik z funkcją wyliczającą aktualne wyjście procesu
	u_gen.m 		- plik generujący pseudolosowe sterowanie dla procesu
	main.m			- plik używany do początkowych symulacji modelu

	get_static.m 	- plik używany do wygenerowania charakterystyki statycznej
	test_model.m 	- plik używany do pół-automatycznego testowania i zapisywania modeli wygenerowanych przez program 'sieci'
	best_model_selector.m	- plik sprawdzający który z wygenerowanych modeli z danej serii jest najlepszy
	gen_for_chosen.m 	- plik generujący wykresy itp dla konkretnego modelu
	get_linear_model.m 	- plik generujący i testujący model liniowy
	matlab_ner.m 	- plik generujący i testujący modele neuronowe matlabowego toolboxa 'Deep Learning Toolbox'

	y_zad_gen.m 	- plik generujący pseudolosowe wartości zadane procesu
	init_regulators.m 	- plik inicjalizujący regulatory
	regulators.m 	- plik symulujący proces z regulatorem
