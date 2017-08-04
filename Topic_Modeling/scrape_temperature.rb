require 'rubygems'
require 'nokogiri'
require 'restclient'
require 'open-uri'

def fetchData(month_min,date_min,year_min,month_max,date_max,year_max)
	startDate = Date.new(year_min, month_min, date_min)
	endDate = Date.new(year_max, month_max, date_max)
	numDays = endDate - startDate

	count = 0
	for i in 0..numDays
		currDate = startDate + i
		year = currDate.year
		month = currDate.month
		day = currDate.day
		url = "https://www.wunderground.com/history/airport/VIDD/#{year.to_s}/#{month.to_s}/#{day.to_s}/DailyHistory.html?req_city=Delhi&req_state=DL&req_statename=India&reqdb.zip=00000&reqdb.magic=57&reqdb.wmo=42182"
		page = Nokogiri::HTML(open(url).read)
		pgc = page.css('span')
		dataID = year.to_s + ',' + month.to_s + ',' + day.to_s + ';'
		puts dataID
		count = count + 1
		strWrite = File.open("delhitemp/day#{dataID}.txt",'w')
		strWrite.puts pgc
	end
	puts count
end

def getTemperature(month_min,date_min,year_min,month_max,date_max,year_max)
	startDate = Date.new(year_min, month_min, date_min)
	endDate = Date.new(year_max, month_max, date_max)
	numDays = endDate - startDate
	#puts numDays.to_s
	sw = File.open('acqWeather.csv','a')
	count = 0
	for i in 0..numDays
		currDate = startDate + i
		year = currDate.year
		month = currDate.month
		day = currDate.day
		dataID = year.to_s + ',' + month.to_s + ',' + day.to_s + ';'
		#puts dataID
		count = count + 1
		strRead = Nokogiri::HTML(File.open("delhitemp/day#{dataID}.txt"))
		strd = strRead.css('span.wx-data')
		for jj in 12..strd.length-1
			tempStr = strd[jj]
			tst = strd[jj].css('span.wx-unit').text
			# if (tst[tst.length-1]=='F')
			# 	puts tempStr.css('span.wx-value').text
			# end	
			tst = ((tst[tst.length-1]=='F') ? tempStr.css('span.wx-value').text : 0)
			sw.puts tst
		end
		tstr = ""
		# for jj in (tempStr.length-520..tempStr.length-1).step(2)
		# 	sw.puts tempStr[jj].text
		# end
		#puts tst
		#puts tempStr
		# puts strRead.css('span.wx-value').length
	end	
	puts count
end

def testGetTemperature(month_min,date_min,year_min,month_max,date_max,year_max)
	startDate = Date.new(year_min, month_min, date_min)
	endDate = Date.new(year_max, month_max, date_max)
	numDays = endDate - startDate
	#puts numDays.to_s
	sw = File.open('delhitemp/acqWeather.csv','a')
	sw.puts "Year,Month,Day,Temp"
	count = 0
	for i in 0..numDays
		currDate = startDate + i
		year = currDate.year
		month = currDate.month
		day = currDate.day
		dataID = year.to_s + ',' + month.to_s + ',' + day.to_s + ';'
		puts dataID
		count = count + 1
		strRead = Nokogiri::HTML(File.open("delhitemp/day#{dataID}.txt"))
		#strd = strRead.css('span.wx-data')
		strd = strRead.css('span')
		#puts strRead.css('span')

		cc1 = 0
		while strd[cc1] != nil
			if strd[cc1].text != '(IST)'
				cc1 += 1
			else
				break
			end
		end

		if strd[cc1]!= nil
			relstrd = strd[cc1+1, strd.length-1].css('span.wx-data')
			#puts relstrd
			skipf = 0
			totalReadings = 0
		
			for jj in 0..relstrd.length-2
				tempStr = relstrd[jj]
				tst = relstrd[jj].css('span.wx-unit')
				if (tst.text[tst.text.length-1] == 'F') and (skipf == 0)
					skipf = 1
					dayNumber = i+1
					sw.puts "#{year.to_s},#{month.to_s},#{day.to_s},#{tempStr.css('span.wx-value').text}" 
					totalReadings+=1
				else
					if (tst.text[tst.text.length-1] != 'F')
						tst = relstrd[jj+1].css('span.wx-unit')
						if (tst.text[tst.text.length-1] == 'F') and (skipf == 1)
							skipf = 0
						end
					end
				end

				# if (tst[tst.length-1]=='F')
				# 	puts tempStr.css('span.wx-value').text
				# end	
				#tst = ((tst[tst.length-1]=='F') ? tempStr.css('span.wx-value').text : 0)
				#puts tst
			end
		end
		puts totalReadings.to_s
		# tstr = ""
		# for jj in (tempStr.length-520..tempStr.length-1).step(2)
		# 	sw.puts tempStr[jj].text
		# end
		#puts tst
		#puts tempStr
		# puts strRead.css('span.wx-value').length
	end	
	#puts count
end

def testGetTimes(month_min,date_min,year_min,month_max,date_max,year_max)
	startDate = Date.new(year_min, month_min, date_min)
	endDate = Date.new(year_max, month_max, date_max)
	numDays = endDate - startDate

	count = 0
	for i in 0..numDays
		currDate = startDate + i
		year = currDate.year
		month = currDate.month
		day = currDate.day
		dataID = year.to_s + ',' + month.to_s + ',' + day.to_s + ';'
		puts dataID
		count = count + 1
		strRead = Nokogiri::HTML(File.open("lahoretemp/day#{dataID}.txt"))
		#strd = strRead.css('span.wx-data')
		strd = strRead.css('span')
		#puts strRead.css('span')s
		cc1 = 0
		while strd[cc1].text != '(IST)'
			cc1 += 1
		end

		relstrd = strd[cc1+1, strd.length-1].css('span.wx-data')
		#puts relstrd
		skipf = 0
		totalReadings = 0

		for jj in 0..relstrd.length-2
			tempStr = relstrd[jj]
			tst = relstrd[jj].css('span.wx-unit')
			if (tst.text[tst.text.length-1] == 'F') and (skipf == 0)
				skipf = 1
				dayNumber = i+1
				sw.puts "#{dayNumber.to_s},#{tempStr.css('span.wx-value').text}" 
				totalReadings+=1
			else
				if (tst.text[tst.text.length-1] != 'F')
					tst = relstrd[jj+1].css('span.wx-unit')
					if (tst.text[tst.text.length-1] == 'F') and (skipf == 1)
						skipf = 0
					end
				end
			end

			# if (tst[tst.length-1]=='F')
			# 	puts tempStr.css('span.wx-value').text
			# end	
			#tst = ((tst[tst.length-1]=='F') ? tempStr.css('span.wx-value').text : 0)
			#puts tst
		end

		puts totalReadings.to_s
		# tstr = ""
		# for jj in (tempStr.length-520..tempStr.length-1).step(2)
		# 	sw.puts tempStr[jj].text
		# end
		#puts tst
		#puts tempStr
		# puts strRead.css('span.wx-value').length
	end	
end


#fetchData(01,01,2010,12,31,2016)
testGetTemperature(01,01,2010,12,31,2016)
#testGetTimes(12,01,2016,12,31,2016)


