Factory.define :user do |f|
  f.username "foo"
  f.password "foobar"
  f.password_confirmation { |u| u.password }
  f.email "foo@test.com"
end
