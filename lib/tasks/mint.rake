namespace :mint do
  desc "TODO"
  task update: :environment do
    User.all.each {|u| u.mint_update }
  end

end
