module BoxScanner
  def checksum(boxes)
    twos = threes = 0
    boxes.each do |box|
      char_counts = box.chars.each_with_object(Hash.new(0)) { |c, h| h[c] += 1 }
      twos += 1 if char_counts.find { |c, count| count == 2 }
      threes += 1 if char_counts.find { |c, count| count == 3 }
    end
    twos * threes
  end

  def common_letters(boxes)
    box1, box2 = common_boxes(boxes)
    box1.chars.zip(box2.chars).each_with_object("") { |(a, b), l| l << a if a == b }
  end

  def common_boxes(boxes)
    box1, *boxes = boxes
    while boxes.length > 0
      boxes.each do |box2|
        return [box1, box2] if similar?(box1, box2)
      end
      box1, *boxes = boxes
    end
  end

  def similar?(box1, box2)
    diffs = 0
    box1.chars.zip(box2.chars).each do |a, b|
      diffs += 1 unless a == b
      return false if diffs > 1
    end
    true
  end

  extend self
end

return unless $PROGRAM_NAME == __FILE__
input = <<-INPUT.strip.split("\n")
bpacnmelhhzpygfsjoxtvkwuor
biacnmelnizqygfsjoctvkwudr
bpaccmllhizyygfsjoxtvkwudr
rpacnmelhizqsufsjoxtvkwudr
bfacnmelhizqygfsjoxtvwwudp
bpacnmelhizqynfsjodtvkyudr
bpafnmelhizqpgfsjjxtvkwudr
bpackmelhizcygfsjoxtvkwudo
bmacnmilhizqygfsjoltvkwudr
bpafnmelhizuygfsjoxtvkwsdr
boacnmylhizqygfsjoxtvxwudr
bpbcjmelhizqygfsjoxtgkwudr
bpacnmglhizqygfsjixtlkwudr
bpacnmclhizqygfsjoxtvkwtqr
bpacnmelhczqygtsjoptvkwudr
bpacnmelhizqywfsaoxtvkbudr
apacnmelhizqygcsjoxtvkwhdr
bpacnmelrizqygfsbpxtvkwudr
tpkcnmelpizqygfsjoxtvkwudr
bpacnmelhizqlgfsjobtmkwudr
npacnmelhizqygffjoxtvkwudf
bpacnmeehqzqygqsjoxtvkwudr
bpecnmelhizqigfsjvxtvkwudr
bpacnmelhizqysfsjoxtvkdfdr
bpacnfelhkzqygfsjoxtvkwfdr
bpacnbelvizqygfsjoxthkwudr
bpacnoelhizqygfejoxtvkwudn
bpacnmelhizqygfzpkxtvkwudr
bpahnmelhizqyufsjoxmvkwudr
bpacnmelhizqygfsnoxtvkwmmr
bpacnmelhizqygfsjoatvkludf
bpacnmylhizqygfsjlxtvksudr
bpacnmekhpzqygysjoxtvkwudr
bpacnselhizqogfswoxtvkwudr
bpacnmelhizqprfsjoxwvkwudr
bpatnmelhinqygfsjoctvkwudr
bpacnqelhqzqygfsxoxtvkwudr
bpabnmelhiyqygfsjoxtykwudr
bpacnivlhizqygfsjoxtviwudr
bpkcnmylhizqygfsjoxtvkwcdr
bpafnmflhizqygtsjoxtvkwudr
bpachmelhizqygfsjixtvkwudg
bpacymelhizqygfsjoxtykwuar
bpacnkelhizqdgfsjoxtskwudr
bpacnmezhizqggbsjoxtvkwudr
bpacnmqlhizqygrsjoxzvkwudr
bpaczmelhizqyhfsjoxfvkwudr
bdacnmelhyzqygusjoxtvkwudr
bpacbmelhizqywfsjostvkwudr
bpacnmelhihzygfstoxtvkwudr
bpactmelhizqygfsjcxtvkwydr
bkacnmethizqytfsjoxtvkwudr
bpacnmalhizqydfskoxtvkwudr
spacnmelbizqygfsjoxdvkwudr
lpalnmelhizoygfsjoxtvkwudr
bpacjmeghizqygfsjoxtviwudr
bpacnmeqhizxygfsjoxgvkwudr
bpacnmelhizqygosjoxtvkkuhr
bpacnmelhiznbxfsjoxtvkwudr
bgacnmelhizqygfsjbxivkwudr
bpacnmelhizqygfjjowtvswudr
bpacnmelhizqygfsjovtgkmudr
bpacnmelcmzqygfspoxtvkwudr
bpvcnmelhizqyvfcjoxtvkwudr
bpacnmeahizqjgfsjoxtvkwukr
bpacnoelwizqygfsjoxtvkaudr
xpacnmelhizqygfsjoxdvkwedr
mpacnmelqizqygfsjoxtvkwudx
bppcnmelhizqygfsjfxtvkhudr
bpacnmclhizqyhfsjaxtvkwudr
opacsmelhizqygfsjmxtvkwudr
bpafnmelhizqjgfsjoxtvkrudr
bpdcnmilhizqygfsjoxtvkludr
bpainmelhizqygfsjtntvkwudr
bradnmelhizqygfsjextvkwudr
bpacnmelhizqygfmsoxtvkwudg
bpacneelhizqygvrjoxtvkwudr
bpacnpelhizqygfsjoxyvkwudf
bpacnmelhizqygfsqoqtvkwodr
bpacnmelhizjyghsjoxcvkwudr
bpacnmelmibqygfsjoxtvnwudr
jpacnmelaizqygfwjoxtvkwudr
zpachmelhizqygfsjsxtvkwudr
bpacnmelfizqykfsjomtvkwudr
bpacnmllwizqygfsjoxtvkwusr
bpaynmelhizqygfsjoxtvowcdr
jpacnmqlhizqygfsjoxtvknudr
bpacxmelhizqyffsjoxtvkwugr
apawnmelhizqygfsjtxtvkwudr
mpacnmelhitqigfsjoxtvkwudr
bpacnmelhhzqygfsjoxtvkyzdr
gpacnmelhizqynfsjoxtvkwudm
bnacnkelhizqygfsjoxtpkwudr
bpacnmelfizqygfsumxtvkwudr
bpacnmelhisqygfsjohtvowudr
bpacnmelhimqygxsjoxtvkwudn
bpscnmeliizqygfsjoxtvkwunr
qpacnmelhizqycfsjoxtvkwndr
bpacnmelhijqygfsjohtvkyudr
bpacnmelhizqykfsjkxtvknudr
bpacnqilhizqygfsjoxtvkoudr
bpacnmelhizqzgmsjoxtvkwurr
bpdcnmelhizqygfsjoutukwudr
bpecnmeghizqygfsjoxgvkwudr
bpicnmelhizqygfrjoxtvlwudr
bpacnmelhizfygfsroxtvkwodr
buacnmelhizqygjsjoxtvkvudr
bpacnmelhixqykfsjoxtvrwudr
bpacnmelhizqygvejcxtvkwudr
bpacnmjlhizqylfsjoxtvkwuor
qpacnmelhizqygfsjoxfdkwudr
bpfcnmemhizqygfsjoxtvknudr
bpacnmelhizqoffsjqxtvkwudr
hpacnielhiqqygfsjoxtvkwudr
gpacnmelhizqygfsewxtvkwudr
bpacnmellizqylxsjoxtvkwudr
bpacnmenhizqymfsjoxtvkmudr
bpacnfelhizqygcsjoltvkwudr
bpacnmelhqqqygfsjoxtvkuudr
bplgnmelhiqqygfsjoxtvkwudr
bpacnzelhizqygfgjoxtvnwudr
bpacnmelhizqygfsjoktvknunr
bpacnmdlhioqygfnjoxtvkwudr
epacnmelwizqyjfsjoxtvkwudr
bpacxmelhazfygfsjoxtvkwudr
bpacnmejhezqygfsjoxtskwudr
bpacnqelhihqyzfsjoxtvkwudr
bpacnbelhizqyrfsjoxtvkmudr
bpacnmelhizqygfsjoxtylwzdr
bpacnmelwizqygfsjodtvkhudr
bpacnnelhizqygfsjoxtwkwadr
bpacimelhizqygfsnoxtvkwuor
bpacnmelhizqyaasjoxtlkwudr
bpacnmelhizqyeffjoxtvkwuds
bpacnmenhizqygxscoxtvkwudr
bpacnmelhidqygfsjowtskwudr
bpacnmeliizqygfsjoxhvkwucr
bpacimelhizqygfsjoxtvktuwr
bpainmelhhzqygfsjzxtvkwudr
bpacamelhizqygfsjogtvkwbdr
bpccnmelgizqygfsjoxtykwudr
bpacnmelhizwegfsjoxtvkwadr
bpackmelhbzqygqsjoxtvkwudr
bpacymeihizqyffsjoxtvkwudr
bpacnielhczqygfsjoxtvkwudk
bpacnmejhizqygffjoxjvkwudr
ppacnmelhizqygfsjoxtigwudr
bpjcnmolhizqygfsjoxtvkwndr
bpacnmelcizqygrsjoxtakwudr
cpawnmelhizqygfsjoxmvkwudr
bwacnmelhizqygesjoxtakwudr
bpacnmelhizqygfsjexsvkwddr
bpaunmelhiuqygfsjoxtvkwtdr
bpacnmellimqygfsjextvkwudr
bpacnmerhizqygfsaoxvvkwudr
bpacnmglhizqygfsjixtukwudr
ppacnmelhizqygfsjoxtvkdudp
bpacnmedhizqygukjoxtvkwudr
bpccnmelhizqngfsjoxtvkwadr
bgacnmeldizqygfscoxtvkwudr
bpacngelhizsygfsjoxtvkwkdr
bpacnpelhizqygfsjoxctkwudr
bpacnmylhizqygfcjoxtvkwmdr
npacnmelhizqygfsjoxtwkwuds
bpaxnmelhizqydfsjoxyvkwudr
bpacnhelhizjygfsjoxtvkmudr
bpacnkelhczqygfnjoxtvkwudr
bfacnmelhizrygfsjoxtvkwodr
bpycnmelhizqygfofoxtvkwudr
qpacpselhizqygfsjoxtvkwudr
bpvcnmelhezqygfsjoxttkwudr
bpacnmwlhizqygfijoxtmkwudr
bsacnmelhikqygfsjoxttkwudr
bpccnxelhizqyafsjoxtvkwudr
bpacnmelhizqygfswhxtvewudr
vpacnmzlhizqygfsvoxtvkwudr
bpacnmelhihqygfsjoxtvkqurr
bpacnmelhixqygazjoxtvkwudr
bpavnmelhizqygfsjozpvkwudr
bpacnmclhizuygfsjoxmvkwudr
bpacnmelhizryufsjoxtkkwudr
bpacnmelhtzqygfsjobtvkwufr
bpacnmelhizqmlfsjoxtvkwudq
bpaaneelhizqygfsjlxtvkwudr
bpacnmelhxzqygfsjoxthkwuhr
bpacnmeshizqygfcjoxtvkwude
bpacnzqlhizqygfsxoxtvkwudr
bgaanmelhizqycfsjoxtvkwudr
bpacnmexhizqygfsroxtvkwudn
bpmmnmelhizqygfajoxtvkwudr
bpacnmelhizqylfsjoxtckwhdr
bpicnmelhizqyrfsjoxtvkwudi
zpacnmelhizvycfsjoxtvkwudr
bpamnmkllizqygfsjoxtvkwudr
bpacnmelhrzqyrfsjoxgvkwudr
bpadnmelhczqygfsjoxtlkwudr
bpacrmelhizqygrsjoxtvkiudr
lpacnmelhizqygfsjoxtgkwxdr
fpacnmalhiuqygfsjoxtvkwudr
bpacnmelhizqygfsjixtvfwcdr
bpccnmelhxzqygfkjoxtvkwudr
bpacnmepaizqygfsjoctvkwudr
tpacnmelhivqygfsxoxtvkwudr
kpacnfelhitqygfsjoxtvkwudr
baacnzelhizqygfsjoxtvkwudx
bcycnmeghizqygfsjoxtvkwudr
wpacotelhizqygfsjoxtvkwudr
bpacnmsshizqygrsjoxtvkwudr
blacnmelhizqygfsjoxtykwvdr
bkacnmelhizqygfsjoxuvkludr
bpacnmelhizaugfsjoxtvhwudr
fpavnmelhizqygfsgoxtvkwudr
bpachmelnizqygfsjextvkwudr
bpacnmelhizqpgfsjoxtvkwldu
bpacnmelhizqygfsloftvywudr
bpacntelhvzqygfejoxtvkwudr
bpacnmeldizqygfsjmxtvkdudr
byacnmelhizqygfsjsxtvkwudh
bpacnmellizqygssxoxtvkwudr
bpacnmelhizqygfsjootvknuir
bpacnmelhitqjgfsjoxivkwudr
bpacnmelhazaygfsjoxtvfwudr
bpacnzenhizqygfsjzxtvkwudr
bpacnmelhizqypfsdoxtvkwuar
bpannmelhizqygnsjoxtvkwndr
bracnmeldizsygfsjoxtvkwudr
bpacnmelhizwygfsjugtvkwudr
bpatnmelhizqygfsjoytvkwulr
upacnmelhizqygfsjurtvkwudr
bpaenmezhizqygfsjostvkwudr
bpacnmelhizpygfsjodhvkwudr
bpacnmelhizqygfsjogtvkguwr
bpacnmelhisqygfsjoxtpkuudr
bxacnmelhizqygfsjdxtvkfudr
bpacnmelhizqygfsjohqvkwudu
bzacnmtlhizqygfsjoxsvkwudr
bpacnmplhixrygfsjoxtvkwudr
bpacnmelhizqhgfsjomtvkwudg
bpacnmezhizqygfsjxxtykwudr
bpacnmwlhizqygfujoxtzkwudr
tpacnmelhizqygfsjoxkvpwudr
bpawsmenhizqygfsjoxtvkwudr
bpacnmelhizqtgfsjoxttkwuqr
bpkcbmelhizqygfsjoxtvkwucr
bpacfmekhizqygfsjoxtvkwuds
bpacnmethizqynfajoxtvkwudr
bpocnmclhizqygfsjoxtvkwukr
zpacnmwlhizqygfsjoxzvkwudr
bpacpoelhqzqygfsjoxtvkwudr
bpacnlelhizqyzfsjoxtvkwukr
INPUT

puts BoxScanner.checksum(input)
puts BoxScanner.common_letters(input)
