hab_install "install habitat"

user 'hab' do
  action :create
end

group 'root' do
  action :modify
  members 'hab'
  append true
end