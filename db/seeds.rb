Organization.delete_all

%w(Hoppinger ElemanTest).each do |org|
  Organization.create(name: org)
end

Organization.all.each do |org|
  org.fetch_repos!
  org.repos.each do |repo|
    repo.contributors.create(name: 'Onur Kucukkece')
  end
end
