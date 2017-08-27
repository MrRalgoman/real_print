local entClass = FindMetaTable("Entity")

function entClass:GetMoney()
	self.rprint_money = self:GetNWInt("rprint_Money")
	return self.rprint_money
end