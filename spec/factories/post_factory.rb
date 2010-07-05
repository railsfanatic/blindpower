Factory.define :post do |f|
  f.association :user
  f.title Populator.words(5..10).titleize
  f.body Populator.sentences(20..50)
end
