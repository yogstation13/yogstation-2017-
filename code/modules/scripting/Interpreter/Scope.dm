/*
	Class: scope
	A runtime instance of a block. Used internally by the interpreter.
*/
/scope
	var
		scope/parent = null
		node/BlockDefinition/block
		list
			functions
			variables

	New(node/BlockDefinition/B, scope/parent)
		block = B
		parent = parent
		variables = B.initial_variables.Copy()
		functions = B.functions.Copy()
		.=..()