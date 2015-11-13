require 'importex'
class Product1 < Importex::Base
    column "name",:required=>true
    column "age",:type=>Integer
end
