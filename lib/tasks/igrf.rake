Rails::TestTask.new("test:igrf") do |t|
  t.pattern = "test/igrf/**/*_test.rb"
end

Rake::Task["test:run"].enhance ["test:igrf"]
