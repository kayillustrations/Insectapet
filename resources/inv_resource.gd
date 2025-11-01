extends Resource
class_name Inv

signal update

var slots: Array[SlotData]

func fill_slots(size:int):
	slots.resize(size)
	for i in size-1:
		slots[i] = SlotData.new()

func finditem(item: ItemData):
	var item_slots:Array[SlotData] = slots.filter(func(slot:SlotData):return slot.item == item)
	if !item_slots.is_empty():
		return item_slots[0].amount

func insert(item: ItemData)-> bool:
	var item_slots:Array[SlotData] = slots.filter(func(slot:SlotData):return slot.item == item)
	if !item_slots.is_empty():
		item_slots[0].amount += 1
		update.emit()
		return true
	else:
		var empty_slots:Array[SlotData] =  slots.filter(func(slot:SlotData):return slot.item == null)
		if !empty_slots.is_empty():
			empty_slots[0].item = item
			empty_slots[0].amount = 1
			update.emit()
			return true
	return false

func switch(item1_slot:int,item2_slot:int):
	var hold_item = slots[item1_slot].item
	var hold_item_amount = slots[item1_slot].amount
	
	slots[item1_slot].item = slots[item2_slot].item
	slots[item1_slot].amount = slots[item2_slot].amount
	
	slots[item2_slot].item = hold_item
	slots[item2_slot].amount = hold_item_amount
	update.emit()

func empty(itemslot: SlotData) -> void:
	itemslot.item = null
	update.emit()
	pass

func drop_item(slot_number:int):
	#SceneLoader.current_player.Spawn_Drop_Items(slots[slot_number].item,slots[slot_number].amount)
	empty(slots[slot_number])
