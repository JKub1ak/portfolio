To run the simulation run file run_simulation.


Parameters and variables (more details in the files):
	run_simulation.m:
		'simLength'	- length of the simulation
		'Fin0'		- starting input value. Does not change if 'regulator'==0.
		'FD0'		- starting noise value. Does not change if 'noise'==0.
		'linear'	- selects between non-linear, linear and fuzzy models
		'init_sim'	- selects between initializing and not initializing simulation
		'regulator'	- selects regulator
		'setpoint'	- set a setpoint for the regulator
		'noise'		- selects between a few noise samples

	init_simulation.m:
		'data':
			'V0' 	- sets initial conditions

	init_regulator_fuzzy_dmc.m:
		'fuzzy_dmc_data':
			'mf'	- selects between different membership functions for the fuzzy regulator
			'points'- choose break points for one of the membership functions variant
			'slopes'- choose sigma values for one of the membership functions variant


File descriptions:
	run_simulation.m			- run the simulation main loop, do setup, plot outcomes.
	init_simulation.m			- initialize simulation constants, values and so on, as well as set starting condition
	init_TS.m					- initialize additional data for fuzzy models and regulator
	init_regulator_dmc.m		- initialize dmc regulator
	init_regulator_fuzzy_dmc.m	- initialize fuzzy dmc regulator
	step_simulation.m			- simulate object one step forward
	step_regulator_dmc.m		- run one step of regulation
	step_regulator_fuzzy_dmc.m	- run one step of fuzzy regulation
	TS{2-5}_lin.m				- calculate fuzzy linearizations for model (ran by step_simulation)