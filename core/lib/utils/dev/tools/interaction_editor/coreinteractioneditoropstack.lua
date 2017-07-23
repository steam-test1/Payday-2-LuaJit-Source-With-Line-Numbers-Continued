core:module("CoreInteractionEditorOpStack")
core:import("CoreClass")
core:import("CoreCode")

InteractionEditorOpStack = InteractionEditorOpStack or CoreClass.class()

-- Lines: 8 to 12
function InteractionEditorOpStack:init()
	self._stack = {}
	self._redo_stack = {}
	self._ops = {save = {name = "save"}}
end

-- Lines: 14 to 16
function InteractionEditorOpStack:has_unsaved_changes()
	local size = #self._stack

	return size > 0 and self._stack[size].op.name ~= "save"
end

-- Lines: 19 to 21
function InteractionEditorOpStack:new_op_type(name, undo_cb, redo_cb)
	self._ops[name] = {
		name = name,
		undo_cb = undo_cb,
		redo_cb = redo_cb
	}
end

-- Lines: 23 to 25
function InteractionEditorOpStack:mark_save()
	self:new_op("save")
end

-- Lines: 27 to 30
function InteractionEditorOpStack:new_op(name, ...)
	table.insert(self._stack, {
		op = assert(self._ops[name]),
		params = {...}
	})

	self._redo_stack = {}
end

-- Lines: 32 to 45
function InteractionEditorOpStack:undo()
	local size = #self._stack

	if size > 0 then
		local op_data = self._stack[size]

		table.insert(self._redo_stack, op_data)
		table.remove(self._stack, size)

		if op_data.op.name ~= "save" then
			op_data.op.undo_cb(op.params)
		else
			self:undo()
		end
	end
end

-- Lines: 47 to 60
function InteractionEditorOpStack:redo()
	local size = #self._redo_stack

	if size > 0 then
		local op_data = self._redo_stack[size]

		table.insert(self._stack, op_data)
		table.remove(self._redo_stack, size)

		if op_data.op.name ~= "save" then
			op_data.op.redo_cb(op.params)
		else
			self:redo()
		end
	end
end

