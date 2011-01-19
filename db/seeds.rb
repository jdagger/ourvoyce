# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

Chamber.destroy_all
[[1, 'House', 'house.png'], [2, 'Senate', 'senate.png']].each do |id, chamber, logo|
  Chamber.create :name => chamber, :logo => logo do |r|
    r.id = id
    r.save
  end
end

MediaType.destroy_all
[[1, 'Magazine', 1, 3, 'magazine.png'],
[2, 'Newspaper', 1, 2, 'newspaper.png'],
[3, 'Radio', 1, 4, 'radio.png'],
[4, 'Television', 1, 1, 'television.png'],
[5, 'TVShow', 2, nil, 'tvshow.png'],
[6, 'RadioShow', 2, nil, 'radioshow.png']].each do |id, name, level, display_order, logo|
  MediaType.create :name => name, :level => level, :display_order => display_order, :logo => logo do |m|
    m.id = id
    m.save
  end
end

GovernmentType.destroy_all
[[1, 'Agency', 'agency.png'],
 [2, 'Executive', 'executive.png'],
 [3, 'Legislative', 'legislative.png']].each do |id, name, logo|
  GovernmentType.create :name => name, :logo => logo do |g|
    g.id = id
    g.save
  end
end

State.destroy_all
[[1, 'AK', 'Alaska', 'seal_ak.jpg'],
[2, 'AZ', 'Arizona', 'seal_az.jpg'],
[3, 'AR', 'Arkansas', 'seal_ar.jpg'],
[4, 'CA', 'California', 'seal_ca.jpg'],
[5, 'CO', 'Colorado', 'seal_co.jpg'],
[6, 'CT', 'Connecticut', 'seal_ct.jpg'],
[7, 'DE', 'Delaware', 'seal_de.jpg'],
[8, 'DC', 'District of Col', 'seal_dc.jpg'],
[9, 'FL', 'Florida', 'seal_fl.jpg'],
[10, 'GA', 'Georgia', 'seal_ga.jpg'],
[11, 'HI', 'Hawaii', 'seal_hi.jpg'],
[12, 'ID', 'Idaho', 'seal_id.jpg'],
[13, 'IL', 'Illinois', 'seal_il.jpg'],
[14, 'IN', 'Indiana', 'seal_in.jpg'],
[15, 'IA', 'Iowa', 'seal_ia.jpg'],
[16, 'KS', 'Kansas', 'seal_ks.jpg'],
[17, 'KY', 'Kentucky', 'seal_ky.jpg'],
[18, 'LA', 'Louisiana', 'seal_la.jpg'],
[19, 'ME', 'Maine', 'seal_me.jpg'],
[20, 'MD', 'Maryland', 'seal_md.jpg'],
[21, 'MA', 'Massachusetts', 'seal_ma.jpg'],
[22, 'MI', 'Michigan', 'seal_mi.jpg'],
[23, 'MN', 'Minnesota', 'seal_mn.jpg'],
[24, 'MS', 'Mississippi', 'seal_ms.jpg'],
[25, 'MO', 'Missouri', 'seal_mo.jpg'],
[26, 'MT', 'Montana', 'seal_mt.jpg'],
[27, 'NE', 'Nebraska', 'seal_ne.jpg'],
[28, 'NV', 'Nevada', 'seal_nv.jpg'],
[29, 'NH', 'New Hampshire', 'seal_nh.jpg'],
[30, 'NJ', 'New Jersey', 'seal_nj.jpg'],
[31, 'NM', 'New Mexico', 'seal_nm.jpg'],
[32, 'NY', 'New York', 'seal_ny.jpg'],
[33, 'NC', 'North Carolina', 'seal_nc.jpg'],
[34, 'ND', 'North Dakota', 'seal_nd.jpg'],
[35, 'OH', 'Ohio', 'seal_oh.jpg'],
[36, 'OK', 'Oklahoma', 'seal_ok.jpg'],
[37, 'OR', 'Oregon', 'seal_or.jpg'],
[38, 'PA', 'Pennsylvania', 'seal_pa.jpg'],
[39, 'RI', 'Rhode Island', 'seal_ri.jpg'],
[40, 'SC', 'South Carolina', 'seal_sc.jpg'],
[41, 'SD', 'South Dakota', 'seal_sd.jpg'],
[42, 'TN', 'Tennessee', 'seal_tn.jpg'],
[43, 'TX', 'Texas', 'seal_tx.jpg'],
[44, 'UT', 'Utah', 'seal_ut.jpg'],
[45, 'VT', 'Vermont', 'seal_vt.jpg'],
[46, 'VA', 'Virginia', 'seal_va.jpg'],
[47, 'WA', 'Washington', 'seal_wa.jpg'],
[48, 'WV', 'West Virginia', 'seal_wv.jpg'],
[49, 'WI', 'Wisconsin', 'seal_wi.jpg'],
[50, 'WY', 'Wyoming', 'seal_wy.jpg'],
[60, 'AL', 'Alabama', 'seal_al.jpg']].each do |id, abbr, name, logo|
  State.create :abbreviation => abbr, :name => name, :logo => logo do |s|
    s.id = id
    s.save
  end
end
