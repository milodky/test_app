# the way to generate this file: rake generate migration file_name ARGS(name:string:index etc)
# if the file follows some convention, the content of this file will be automatically generated
# for you
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps null: false
    end
  end
end
