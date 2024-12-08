# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Destroying all records"

Invoice.destroy_all
Order.destroy_all
Service.destroy_all
Variable.destroy_all
Contract.destroy_all
Supplier.destroy_all
User.destroy_all

puts "Creating users"
User.create(email: "bensouc@vroadstudio.fr", password: "secret")

puts "Creating suppliers"
puts "TODO"

puts "Creating contracts"
contract1 = Contract.create(name: "Shipping Agent")
tax1 = TaxRegime.create( name: "VAT20", contract: contract1, isfee: false, percentage: 20)
tax2 = TaxRegime.create( name: "FEE5", contract: contract1, isfee: true, percentage: 5)
puts "#{contract1.name} with #{tax1.name} and #{tax2.name}"

root = Service.create(contract: contract1, name: "Port Call SOV", description: "All items for SOV portcall in this port", ancestry:"/" )
puts "#{root.name}"

  child1 = Service.create(contract: contract1, name: "Pilotage", description: "", parent:root )
  tax1.services << child1
  tax1.save!
  puts "  #{child1.name} with #{tax1.name}"

    child11 = Service.create(contract: contract1, name: "Pilot inwards", description: "", parent:child1 )
      var11 = Variable.create(service: child11, name: "duration (hours)", value: "24", position:1, operator: false, fixed: false )
      var12 = Variable.create(service: child11, name: "+", value: "+", position:2, operator: true, fixed: true )
      var13 = Variable.create(service: child11, name: "category factor", value: "1.376", position:3, operator: false, fixed: false )
      var14 = Variable.create(service: child11, name: "x", value: "*", position:4, operator: true, fixed: true )
      var15 = Variable.create(service: child11, name: "LOA (m)", value: "81", position:5, operator: false, fixed: false )
    puts "    #{child11.name}  :  #{var11.name} #{var12.name} #{var13.name} #{var14.name} #{var15.name} "

    child12 = Service.create(contract: contract1, name: "Pilot Outwards", description: "", parent:child1 )
      var21 = Variable.create(service: child12, name: "duration (hours)", value: "24", position:1, operator: false, fixed: false )
      var22 = Variable.create(service: child12, name: "+", value: "+", position:2, operator: true, fixed: true )
      var23 = Variable.create(service: child12, name: "category factor", value: "0.885", position:3, operator: false, fixed: false )
      var24 = Variable.create(service: child12, name: "x", value: "*", position:4, operator: true, fixed: true )
      var25 = Variable.create(service: child12, name: "LOA (m)", value: "81", position:5, operator: false, fixed: false )
    puts "    #{child12.name}  :  #{var21.name} #{var22.name} #{var23.name} #{var24.name} #{var25.name} "

  child2 = Service.create(contract: contract1, name: "Linesmen", description: "", parent:root )
    var121 = Variable.create(service: child2, name: "Lumpsum category vessel (€) ", value: "890", position:1, operator: false, fixed: false )
  puts "  #{child2.name}  :  #{var121.name}"

  child3 = Service.create(contract: contract1, name: "Port", description: "", parent:root )
  puts "  #{child3.name}"

    child31 = Service.create(contract: contract1, name: "Vessel traffic services", description: "", parent:child3 )
      var311 = Variable.create(service: child31, name: "LOA (m) ", value: "81", position:1, operator: false, fixed: false )
      var312 = Variable.create(service: child31, name: "x", value: "*", position:2, operator: true, fixed: true )
      var313 = Variable.create(service: child31, name: "A", value: "92.44", position:3, operator: false, fixed: false )
      var314 = Variable.create(service: child31, name: "+", value: "+", position:4, operator: true, fixed: true )
      var315 = Variable.create(service: child31, name: "Duration port call (h) ", value: "37", position:5, operator: false, fixed: false )
      var316 = Variable.create(service: child31, name: "x", value: "*", position:6, operator: true, fixed: true )
      var317 = Variable.create(service: child31, name: "B", value: "143.77", position:7, operator: false, fixed: false )
    puts "      #{child31.name}  :  #{var311.name} #{var312.name} #{var313.name} #{var314.name} #{var315.name} #{var316.name} #{var317.name} "

    child32 = Service.create(contract: contract1, name: "Douane", description: "", parent:child3 )
      var321 = Variable.create(service: child32, name: "Lumpsum (€)", value: "500", position:1, operator: false, fixed: false )
    puts "      #{child32.name}  :  #{var321.name} "

    child33 = Service.create(contract: contract1, name: "Extra Port Fee 2024", description: "", parent:child3 )
      var331 = Variable.create(service: child33, name: "Lumpsum (€)", value: "223", position:1, operator: false, fixed: false )
    puts "      #{child33.name}  :  #{var331.name} "

  child4 = Service.create(contract: contract1, name: "Garbage", description: "", parent:root )
  tax2.services << child4
  tax2.save!
  puts "  #{child4.name} with #{tax2.name}"
    child41 = Service.create(contract: contract1, name: "Garbage disposal", description: "", parent:child4 )
      var411 = Variable.create(service: child41, name: "C", value: "300", position:1, operator: false, fixed: false )
      var412 = Variable.create(service: child41, name: "x", value: "*", position:2, operator: true, fixed: true )
      var413 = Variable.create(service: child41, name: "Number of items ", value: "5", position:3, operator: false, fixed: false )
    puts "      #{child41.name}  :  #{var411.name} #{var412.name} #{var413.name} "

    child42 = Service.create(contract: contract1, name: "Garbage skip rent", description: "", parent:child4 )
      var421 = Variable.create(service: child42, name: "Price per day (€) ", value: "52", position:1, operator: false, fixed: false )
      var422 = Variable.create(service: child42, name: "x", value: "*", position:2, operator: true, fixed: true )
      var423 = Variable.create(service: child42, name: "Days ", value: "5", position:3, operator: false, fixed: false )
    puts "      #{child42.name}  :  #{var421.name} #{var422.name} #{var423.name} "


  child5 = Service.create(contract: contract1, name: "Agency Fee Port Call SOV", description: "", parent:root )
    var51 = Variable.create(service: child5, name: "Negotiated Lumpsum (€) ", value: "800", position:1, operator: false, fixed: false )
  puts "  #{child5.name}  : #{var51.name} "=======
