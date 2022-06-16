function cur_lfp = get_electrode(cur_file,index)
% LFP-File correspondance
% D can contain up to 5 channels

if nargin ==1
    index = 1;
end

D = [{'20141216_225758_E','09-extra$10-extra','07-extra$05-extra','000','000','000'};
    {'20141226_154835_E','08-extra$09-extra','06-extra$05-extra','000','000','000'};
    {'20150223_170742_E','11-extra$08-extra','05-extra$06-extra','000','000','000'};
    {'20150224_175307_E','11-extra$08-extra','05-extra$06-extra','000','000','000'};
    {'20150225_154031_E','11-extra$08-extra','05-extra$06-extra','000','000','000'};
    {'20150226_173600_E','11-extra$08-extra','05-extra$06-extra','000','000','000'};
    {'20150227_134434_E','11-extra$08-extra','05-extra$06-extra','000','000','000'};
    {'20150304_150247_E','11-extra$08-extra','05-extra$06-extra','000','000','000'};
    {'20150305_190451_E','11-extra$08-extra','05-extra$06-extra','000','000','000'};
    {'20150306_162342_E','11-extra$08-extra','05-extra$06-extra','000','000','000'};
    {'20150619_132607_E','06-extra$04-extra','04-extra$07-extra','000','000','000'};
    {'20150620_175137_E','05-extra$07-extra','06-extra$05-extra','000','000','000'};
    {'20150714_191128_E','06-extra$07-extra','05-extra$06-extra','000','000','000'};
    {'20150715_181141_E','06-extra$07-extra','05-extra$06-extra','000','000','000'};
    {'20150716_130039_E','06-extra$07-extra','05-extra$06-extra','000','000','000'};
    {'20150717_133756_E','06-extra$07-extra','05-extra$06-extra','000','000','000'};
    {'20150718_135026_E','06-extra$07-extra','05-extra$06-extra','000','000','000'};
    {'20150722_121257_E','06-extra$07-extra','05-extra$06-extra','000','000','000'};
    {'20150723_123927_E','06-extra$07-extra','05-extra$06-extra','000','000','000'};
    {'20150724_131647_E','06-extra$07-extra','05-extra$06-extra','000','000','000'};
    {'20150725_130514_E','06-extra$07-extra','05-extra$06-extra','000','000','000'};
    {'20151126_170516_E','05-extra$02-extra','04-extra$05-extra','000','000','000'};
    {'20151127_120039_E','05-extra$02-extra','04-extra$05-extra','000','000','000'};
    {'20151128_133929_E','02-extra$06-extra','04-extra$05-extra','000','000','000'};
    {'20151201_144024_E','05-extra$02-extra','04-extra$05-extra','000','000','000'};
    {'20151202_141449_E','05-extra$02-extra','04-extra$05-extra','000','000','000'};
    {'20151203_113703_E','05-extra$02-extra','04-extra$05-extra','000','000','000'};
    {'20151204_135022_E','02-extra$06-extra','04-extra$05-extra','000','000','000'};
    {'20160622_122940_E','06-extra$05-extra','07-extra$08-extra','000','000','000'};
    {'20160622_191334_E','04-extra$07-extra','08-extra$04-extra','000','000','000'};
    {'20160623_123336_E','08-extra$06-extra','04-extra$08-extra','000','000','000'};
    {'20160623_163228_E','05-extra$06-extra','08-extra$05-extra','000','000','000'};
    {'20160623_193007_E','04-extra$07-extra','08-extra$04-extra','000','000','000'};
    {'20160624_120239_E','04-extra$07-extra','08-extra$04-extra','000','000','000'};
    {'20160624_171440_E','05-extra$04-extra','07-extra$08-extra','000','000','000'};
    {'20160625_113928_E','08-extra$06-extra','04-extra$08-extra','000','000','000'};
    {'20160625_163710_E','04-extra$07-extra','08-extra$04-extra','000','000','000'};
    {'20160628_171324_E','05-extra$04-extra','07-extra$08-extra','000','000','000'};
    {'20160629_134749_E','05-extra$04-extra','07-extra$08-extra','000','000','000'};
    {'20160629_191304_E','05-extra$07-extra','08-extra$05-extra','000','000','000'};
    {'20160630_114317_E','05-extra$04-extra','07-extra$08-extra','000','000','000'};
    {'20160701_130444_E','05-extra$04-extra','07-extra$08-extra','000','000','000'};];

ind_file = strcmp(D(:,1),cur_file);
if ~isempty(ind_file)
    cur_lfp = D(ind_file,index+1);
else
    cur_lfp = {};
end

end