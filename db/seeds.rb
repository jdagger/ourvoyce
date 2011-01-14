# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

Chamber.destroy_all

i = 1
[[1, 'House'], [2, 'Senate']].each do |id, chamber|
  Chamber.create :name => chamber do |r|
    r.id = id
    r.save
  end
  i+=1
end

MediaType.destroy_all
[[1, 'Magazine', 1, 3],
[2, 'Newspaper', 1, 2],
[3, 'Radio', 1, 4],
[4, 'Television', 1, 1],
[5, 'TVShow', 2, nil],
[6, 'RadioShow', 2, nil]].each do |id, name, level, display_order|
  MediaType.create :name => name, :level => level, :display_order => display_order do |m|
    m.id = id
    m.save
  end
end

GovernmentType.destroy_all
[[1, 'Agency'], [2, 'Executive'], [3, 'Legislative']].each do |id, name|
  GovernmentType.create :name => name do |g|
    g.id = id
    g.save
  end
end

State.destroy_all
[[1, 'AK', 'Alaska'],
[2, 'AZ', 'Arizona'],
[3, 'AR', 'Arkansas'],
[4, 'CA', 'California'],
[5, 'CO', 'Colorado'],
[6, 'CT', 'Connecticut'],
[7, 'DE', 'Delaware'],
[8, 'DC', 'District of Col'],
[9, 'FL', 'Florida'],
[10, 'GA', 'Georgia'],
[11, 'HI', 'Hawaii'],
[12, 'ID', 'Idaho'],
[13, 'IL', 'Illinois'],
[14, 'IN', 'Indiana'],
[15, 'IA', 'Iowa'],
[16, 'KS', 'Kansas'],
[17, 'KY', 'Kentucky'],
[18, 'LA', 'Louisiana'],
[19, 'ME', 'Maine'],
[20, 'MD', 'Maryland'],
[21, 'MA', 'Massachusetts'],
[22, 'MI', 'Michigan'],
[23, 'MN', 'Minnesota'],
[24, 'MS', 'Mississippi'],
[25, 'MO', 'Missouri'],
[26, 'MT', 'Montana'],
[27, 'NE', 'Nebraska'],
[28, 'NV', 'Nevada'],
[29, 'NH', 'New Hampshire'],
[30, 'NJ', 'New Jersey'],
[31, 'NM', 'New Mexico'],
[32, 'NY', 'New York'],
[33, 'NC', 'North Carolina'],
[34, 'ND', 'North Dakota'],
[35, 'OH', 'Ohio'],
[36, 'OK', 'Oklahoma'],
[37, 'OR', 'Oregon'],
[38, 'PA', 'Pennsylvania'],
[39, 'RI', 'Rhode Island'],
[40, 'SC', 'South Carolina'],
[41, 'SD', 'South Dakota'],
[42, 'TN', 'Tennessee'],
[43, 'TX', 'Texas'],
[44, 'UT', 'Utah'],
[45, 'VT', 'Vermont'],
[46, 'VA', 'Virginia'],
[47, 'WA', 'Washington'],
[48, 'WV', 'West Virginia'],
[49, 'WI', 'Wisconsin'],
[50, 'WY', 'Wyoming'],
[60, 'AL', 'Alabama']].each do |id, abbr, name|
  State.create :abbreviation => abbr, :name => name do |s|
    s.id = id
    s.save
  end
end
