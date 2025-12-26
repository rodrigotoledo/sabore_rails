require 'faker'
require 'open-uri'
require 'net/http'

# Helper para baixar imagens de LoremPicsum
def download_image(width, height, seed = nil)
  url = "https://picsum.photos/#{width}/#{height}"
  url += "?random=#{seed}" if seed

  begin
    URI.open(url)
  rescue => e
    puts "Erro ao baixar imagem: #{e.message}"
    nil
  end
end

# Limpar dados existentes
puts "Limpando dados existentes..."
CategoriesEstablishment.delete_all
Reservation.delete_all
Establishment.delete_all
Category.delete_all
User.delete_all

# Configurar Faker para português
Faker::Config.locale = 'pt-BR'

puts "Criando categorias..."
categories_data = [
  { name: "Pizza", icon: "🍕" },
  { name: "Hambúrguer", icon: "🍔" },
  { name: "Sushi", icon: "🍣" },
  { name: "Brasileira", icon: "🍖" },
  { name: "Italiana", icon: "🍝" },
  { name: "Vegetariana", icon: "🥗" },
  { name: "Doces", icon: "🍰" },
  { name: "Café", icon: "☕" },
  { name: "Churrasco", icon: "🥩" },
  { name: "Frutos do Mar", icon: "🦐" },
  { name: "Mexicana", icon: "🌮" },
  { name: "Árabe", icon: "🥙" }
]

categories = categories_data.map do |cat_data|
  Category.create!(
    name: cat_data[:name],
    icon: cat_data[:icon]
  )
end

puts "Criando estabelecimentos com dados realistas..."

# Tipos de estabelecimentos
establishment_types = [ 'restaurant', 'fast_food', 'cafe', 'bar', 'food_truck' ]

# Coordenadas de São Paulo (região central)
sp_lat_base = -23.5505
sp_lng_base = -46.6333

30.times do |i|
  category = categories.sample

  # Gerar nomes realistas baseados na categoria
  name = case category.name
  when "Pizza"
            [ "Pizzaria #{Faker::Name.last_name}", "#{Faker::Name.first_name} Pizza", "Pizza #{Faker::Address.community}" ].sample
  when "Hambúrguer"
            [ "Burger #{Faker::Name.last_name}", "#{Faker::Name.first_name} Burgers", "Hamburgueria #{Faker::Address.community}" ].sample
  when "Sushi"
            [ "Sushi #{Faker::Name.first_name}", "Restaurante Japonês #{Faker::Name.first_name}", "#{Faker::Name.last_name} Sushi" ].sample
  when "Café"
            [ "Café #{Faker::Name.first_name}", "Cafeteria #{Faker::Address.community}", "#{Faker::Name.last_name} Coffee" ].sample
  else
            "#{category.name} #{Faker::Name.last_name}"
  end

  # Coordenadas variadas em SP
  lat_variation = rand(-0.05..0.05)
  lng_variation = rand(-0.05..0.05)

  establishment = Establishment.create!(
    name: name,
    description: Faker::Restaurant.description,
    address: "#{Faker::Address.street_address}, #{Faker::Address.city_prefix} - São Paulo, SP",
    phone: Faker::PhoneNumber.cell_phone,
    rating: rand(3.5..5.0).round(1),
    establishment_type: establishment_types.sample,
    latitude: sp_lat_base + lat_variation,
    longitude: sp_lng_base + lng_variation
  )

  # Associar categoria
  establishment.categories << category

  # Adicionar logo (1 em cada 3 estabelecimentos)
  if i % 3 == 0
    puts "Adicionando logo para #{establishment.name}..."
    logo_file = download_image(200, 200, i)
    if logo_file
      establishment.logo.attach(io: logo_file, filename: "logo_#{i}.jpg", content_type: "image/jpeg")
    end
  end

  # Adicionar fotos (1 em cada 2 estabelecimentos, 2-5 fotos)
  if i % 2 == 0
    photo_count = rand(2..5)
    puts "Adicionando #{photo_count} fotos para #{establishment.name}..."

    photo_count.times do |photo_i|
      photo_file = download_image(600, 400, i * 10 + photo_i)
      if photo_file
        establishment.photos.attach(
          io: photo_file,
          filename: "photo_#{i}_#{photo_i}.jpg",
          content_type: "image/jpeg"
        )
      end
    end
  end

  print "."
end

puts "\nCriando usuários de exemplo..."

# Usuário principal para testes
user = User.create!(
  email_address: "teste@exemplo.com",
  password: "123456",
  password_confirmation: "123456"
)

# Mais alguns usuários
5.times do
  User.create!(
    email_address: Faker::Internet.email,
    password: "123456",
    password_confirmation: "123456"
  )
end

puts "Criando reservas realistas..."

establishments = Establishment.all
users = User.all

# Reservas futuras (ativas)
15.times do
  establishment = establishments.sample
  user_for_reservation = users.sample

  future_date = Faker::Time.between(from: 1.day.from_now, to: 30.days.from_now)

  Reservation.create!(
    establishment: establishment,
    user: user_for_reservation,
    date: future_date,
    people_count: rand(1..8),
    email: user_for_reservation.email_address,
    status: [ 'pending', 'confirmed' ].sample
  )
end

# Reservas passadas (histórico)
20.times do
  establishment = establishments.sample
  user_for_reservation = users.sample

  past_date = Faker::Time.between(from: 6.months.ago, to: 1.day.ago)

  Reservation.create!(
    establishment: establishment,
    user: user_for_reservation,
    date: past_date,
    people_count: rand(1..8),
    email: user_for_reservation.email_address,
    status: [ 'completed', 'cancelled' ].sample
  )
end

# Algumas reservas anônimas
10.times do
  establishment = establishments.sample
  future_date = Faker::Time.between(from: 1.day.from_now, to: 15.days.from_now)

  Reservation.create!(
    establishment: establishment,
    user: nil,
    date: future_date,
    people_count: rand(1..6),
    email: Faker::Internet.email,
    status: [ 'pending', 'confirmed' ].sample
  )
end

puts "\n\n✅ Seeds concluídas com sucesso!"
puts "\n📊 Resumo:"
puts "- #{Category.count} categorias criadas"
puts "- #{Establishment.count} estabelecimentos criados"
puts "- #{User.count} usuários criados"
puts "- #{Reservation.count} reservas criadas"
puts "- #{Establishment.joins(:logo_attachment).count} estabelecimentos com logo"
puts "- #{Establishment.joins(:photos_attachments).count} estabelecimentos com fotos"

puts "\n🔐 Login de teste:"
puts "Email: teste@exemplo.com"
puts "Senha: 123456"
