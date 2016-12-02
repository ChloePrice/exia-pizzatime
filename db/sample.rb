Base.create!(name: 'Tomate')
Base.create!(name: 'Crème')

Pizza.create!(name: 'Margaritta', price: 6.5, description: 'Oune délicious pizza!', base_id: Base.first.id)
Pizza.create!(name: 'Savoyarde', price: 6.5, description: 'Oune délicious pizza!', base_id: Base.last.id)

OrderEndDay.create(end_day: Date.new)