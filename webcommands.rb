require 'execjs'
require 'date'
require 'win32ole'
require 'fileutils'

class SetupTest
	attr_accessor :b
	attr_accessor :bt
	def initialize(browsertype)
		#client = Selenium::WebDriver::Remote::Http::Default.new
		#client.timeout = 300 #seconds
		@bt = browsertype
		if @bt == 'ff' then
			@b = Watir::Browser.new :ff
			@b.window.resize_to(1280,1024)
			@b.driver.manage.timeouts.implicit_wait = 10
		end
		if @bt == 'ie' then
			Watir.driver = :webdriver
			@b = Watir::Browser.new :ie
		end
		if @bt == 'chrome' then
			@b = Watir::Browser.new :chrome
			#@b.driver.manage.timeouts.implicit_wait = 3
		end
		if @bt == 'safari' then
			@b = Watir::Browser.new :safari
			@b.driver.manage.timeouts.implicit_wait = 10
		end
	end
end

class MobileTest
	attr_accessor :m
	attr_accessor :md
	attr_accessor :ip
	def initialize(mobiledevice, ipaddress)
		@md = mobiledevice
		@ip = ipaddress
		@m = Selenium::WebDriver.for(:remote, :url => @ip)		
	end
end

class UpdateSheet
	attr_accessor :sheet
	attr_accessor :fr
	attr_accessor :workbook
	attr_accessor :excel
	attr_accessor :execute
	
	def initialize(testname, savefile, started)
		@excel = WIN32OLE.new('Excel.Application')
		if started == true then
			@workbook = @excel.Workbooks.open(savefile)
		else
			@workbook = @excel.Workbooks.Open(testname)
		end
		@sheet = @workbook.Worksheets(5)
		@execute = @workbook.Worksheets(4)
		@workbook.Application.DisplayAlerts = false
	end
end


def JavaAction(element, action)
	position = element.location()
	@Javascript  = "$(document.elementFromPoint(#{position.x}, #{position.y})).trigger('" + action + "');"
	@Javascript
end

def WrapUpAction(mt, action, t)
	mt.m.execute_script("javascript:#{action}")
	sleep 0.5
end


def navigate(st, sht, url, t)
		st.b.goto(url)
		sleep 1
end

def refresh(st, sht, t)
	st.b.refresh
end

def is_number?(s)
	s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false:true
end

def settext (st, sht, type, tag, object, index, value, t)
	if value == 'CurrentDate' then
		value = $CurDate
	end
	if is_number?(value) == true then
		value = value.to_i
		number = 'true'
	end
	specifier = {tag => object}
	
	if type != 'input' then
		if number != 'true' then
			if value != nil and value.downcase != 'clear' then
				st.b.text_field(specifier).set value
			else
				st.b.text_field(specifier).clear
			end
		else
			if value != nil then
				st.b.text_field(specifier).set value
			end
		end
	else
		if number != 'true' then
			if value != nil and value.downcase != 'clear' then
				st.b.input(specifier).send_keys value
			else
				st.b.text_field(specifier).clear
			end
		else
			if value != nil then
				st.b.input(specifier).send_keys value
			end
		end
	end
end

def radioset (st, sht, type, tag, object, index, value, t, tag2, object2)
	specifier = {tag => object}
	specifier2 = {tag2 => object2}
	if type == nil then
		st.b.radio(specifier).set
	else
		if type.downcase == 'iframe' then
			iframe = st.b.frame(specifier)
			iframe.button(specifier2).click
		end
	end
end

def clickbutton (st, sht, type, tag, object, index, value, t, tag2, object2)
	specifier = {tag => object}
	specifier2 = {tag2 => object2}
	if object.downcase["add"] == "add" then
		sleep 1
	end
	if type == 'iframe' then
		iframe = st.b.frame(specifier)
		iframe.button(specifier2).click()
	else
		st.b.button(specifier).click()
	end
	if object.downcase["add"] == "add" or object.downcase["yes"] == "yes" then
		sleep 5
	else	
		sleep 2
	end
end

def clickgriditem (st, sht, type, tag, object, index, value, t, tag2, object2)
	#puts "Executing line: #{t} - Click grid Item"
	sleep 0.5
	griddata = st.b.div(tag => object).text()
	gridtext = griddata.split(/\n/)
	gridcount = gridtext.count - 1
	for i in 0..gridcount
		if gridtext[i][value] == value then
			if type == 'image' then
				if object == 'gridDataWrapper' then
					i = i -7
				end
				st.b.image(tag2 => object2, :index => i).click()
			end
			break
		end
	end
	sleep 0.5
end

def clickimage (st, sht, type, tag, object,index,  value, t)
	specifier = {tag => object}
	st.b.image(specifier).click
	if object.downcase == 'sign in' then
		sleep 5
	else
		sleep 0.5
	end
end

def clicklabel (st, sh, type, tag, object, index, value, t)
	if object.downcase == 'value' then
		object = value
	end
	specifier = {tag => object}
	st.b.label(specifier).click
end

def verifypagetitle (st, sht, value, t)
	if st.b.title[value] == value then
		sht.fr = "Pass"
	else
		sht.fr = "Fail"
	end
end

def verifynotonpage (st, sht, value, t)
	x = st.b.text.include? value
	if x == false then
		sht.fr = "Pass"
	else
		sht.fr = "Fail"
	end
end

def verifypage (st, sht, value, t)
	x = st.b.text.include? value
	if x == true then
		sht.fr = "Pass"
	else
		sht.fr = "Fail"
	end
end

def verifytextfield (st, sht, type, tag, object, index, value, t, tag2, object2)
	specifier = {tag => object}
	textvalue = st.b.text_field(specifier).value
	if is_number?(value) == true then
		number = 'true'
	end
	if number != 'true' then
		if textvalue.downcase == value.downcase then
			sht.fr = "Pass"
		else
			sht.fr = "Fail"
		end
	else
		if textvalue.to_i == value.to_i then
			sht.fr = "Pass"
		else
			sht.fr = "Fail"
		end
	end
end

def verifycontacttype (st, sht, type, tag, object, index, value, t, tag2, object2)
	verify = 'false'
	specifier = {tag => object}
	if type.downcase == 'span' then
		test = st.b.span(specifier)
		if test.text() == value then
			verify = 'true'
		end
	end
	if verify == 'true' then
		sht.fr = "Pass"
	else
		sht.fr = "Fail"
	end
end

def verifycontactname (st, sht, type, tag, object, index, value, t, tag2, object2)
	verify = 'false'
	specifier = {tag => tag}
	if type.downcase == 'span' then
			test = st.b.span(specifier)
			if test.text() == value then
				verify = 'true'
			end
	end
	if verify == 'true' then
		sht.fr = 'Pass'
	else
		sht.fr = 'Fail'
	end
end

def verifyinputfield (st, sht, type, tag, object, index, value, t, tag2, object2)
	verify = 'false'
	specifier = {tag => object}
	if type.downcase == 'input' then
		test = st.b.input(specifier)
		if test.attribute_value("value").to_s == value.to_s then
			verify = 'true'
		end
	end
	if verify == 'true' then
		sht.fr = 'Pass'
	else
		shr.fr = 'Fail'
	end
end

def clicksubmenu (st, sht, type, tag, object, index, value, t, tag2, object2)
	#puts "Executing line : #{t}"
	specifier = {tag => object}
	specifier2 = {tag2 => object2}
	st.b.refresh
	sleep 0.5
	st.b.send_keys :page_up
	sleep 0.5
	st.b.send_keys :page_up
	if st.bt.downcase != 'ie' then
		st.b.link(specifier).hover
		st.b.link(specifier2).click()
	else
		st.b.link(specifier).hover
		sleep 0.5
		st.b.link(specifier2).click()
	end
	sleep 1.5
end

def clicklink (st, sht, type, tag, object, index, value, t)
	specifier =  {tag => object}
	st.b.link(specifier).click
	if object.downcase == 'ctl00_contentplace_lbproperties' or object.downcase == 'send market snapshot' or object.downcase == 'ctl00_contentplace_lbactivities' or object.downcase == 'ctl00_contentplace_lbassociates' then
		sleep 2
	else
		sleep 0.5
	end
end

def clickspan (st, sht, type, tag, object, index, value, t)
	specifier = {tag => object}
	st.b.span(specifier).click
	sleep 0.5
end

def clickinput (st, sht, type, tag, object, index, value, t)
	specifier = {tag => object}
	st.b.input(specifier).click
	sleep 0.5
end

def selectlist (st, sht, type, tag, object, index, value, t, tag2, object2)
	if value.downcase == 'zero' then
		value = '0'
	end
	specifier = {tag => object}
	specifier2 = {tag2 => object2}
	if type != 'iframe' then
		if value.downcase != 'clear' then
			st.b.select_list(specifier).select value
		else
			st.b.select_list(specifier).clear
		end
	else
		iframe = st.b.frame(specifier)
		if value.downcase != 'clear' then
			iframe.select_list(specifier2).select value
		else
			iframe.select_list(specifier2).clear
		end
	end
	sleep 0.5
end

def selectfile (st, sht, type, tag, object, index, value, t, tag2, object2)
	specifier = {tag => object}
	specifier2 = {tag2 => object2}
	filename = Dir.pwd + '/' + value
	filename["/"] = "\\"
	if type == 'iframe' then
		iframe = st.b.frame(specifier)
		iframe.file_field(specifier2).set filename
	else
		st.b.file_field(specifier).set filename
	end
end

def iframeclick (st, sht, type, tag, object, index, value, t,  tag2, object2)
	specifier = {tag => object}
	specifier2 = {tag2 => object2}
	st.b.frame(specifier).link(specifier2).click
	sleep 5
end

def alert (st, sht, type, tag, object, index, value, t, tag2, object2)
	st.b.execute_script("window.alert = function() {}")
	if value == 'Accept' then
		st.b.execute_script("window.confirm = function() {return true}")
	else
		st.b.execute_script("window.confirm = function() {return false}")
	end
	specifier = {tag => object}
	if type.downcase == 'link' then
		st.b.link(specifier).click
	end
	if type.downcase == 'image' then
		st.b.image(specifier).click
	end
end

def sethour(t)
	chour = (Time.now.hour).to_i
	if chour > 12 then
		chour = chour - 12
	end
	$uhour = chour + 1
end

def gettime (t)
	$CurHour = (Time.now.hour).to_i
	if $CurHour > 12 then
		$CurHour = $CurHour - 12
	end
	$CurHour = $CurHour.to_s
	$CurMin = Time.now.strftime("%M")
end

def getdate (value, t)
	if value == nil then
		month = Time.now.strftime("%B")
		day = Time.now.strftime("%d").sub(/^[0]*/,'')
		year = Time.now.strftime("%Y")
		#$CurDate = (Time.now.strftime("%B %d, %Y")).to_s
		$CurDate = month + ' ' + day + ', ' + year
	else
		$CurDate = (Time.now.strftime("%Y-%m-%d")).to_s
	end
end

def verifytimestamp (st, sht, type, tag, object, index, value, t, tag2, object2)
	verify = 'false'
	specifier = {tag => object}
	if type.downcase  == 'span' then
		if tag != 'xpathlist' and tag != 'classlist' and tag != 'csslist' then
			element = st.b.span(specifier)
			ctime = $CurHour + ":" + $CurMin
			result = element.text()
			#puts "Result: #{result}, time: #{ctime}"
			if result[ctime] == ctime then
				verify = 'true'
			end
		end
	end
	if verify == 'true' then
		sht.fr = 'Pass'
	else
		sht.fr = 'Fail'
	end
end

def verifydate (st, sht, type, tag, object, index, value, t, tag2, object2)
	verify = 'false'
	specifier = {tag => object}
	if type.downcase == 'span' then
		if tag != 'xpathlist' and tag != 'classlist' and tag != 'csslist' then
			element = st.b.span(specifier)
			result = element.text()
			#puts "Result: #{result}, date: #{$CurDate}"
			if result[$CurDate] == $CurDate then
				verify = 'true'
			end
		end
	end
	if verify == 'true' then
		sht.fr = 'Pass'
	else
		sht.fr = 'Fail'
	end
end

def verifycontactstatus (st, sht, type, tag, object, index, value, t, tag2, object2)
	verify = 'false'
	specifier = {tag => object}
	if type.downcase == 'span' then
		if tag != 'xpathlist' and tag != 'classlist' and tag != 'csslist' then
			element = st.b.span(specifier)
			result = element.text()
			if result.downcase == value.downcase then
				verify = 'true'
			end
		end
	end
	if verify == 'true' then
		sht.fr = 'Pass'
	else
		sht.fr = 'Fail'
	end
end

def waitforprocess (st, sht, type, tag, object, index, value, t)
	sleep 1 until st.b.text.include? value
	sleep 1.5
end

def waitforprocess2 (st, sht, type, tag, object, index, value, t)
	sleep 1 until !st.b.text.include? value
	sleep 1.5
end
def clicktext (st, sht, type, tag, object, index, value, t)
	if index != nil then
		st.b.link(:text => value, :index => index.to_i).click
	else
		st.b.link(:text => value).click
	end
	sleep 0.5
end

def switchto (st, sht, type, tag, object, index, value, t)
	lastwindow =  st.b.windows.count
	lastwindow = lastwindow - 1 
	st.b.windows[lastwindow].use
end

def closelatest(st, sht, type, tag, object, index, value, t)
	st.b.windows.last.close
end

def cleanlogin(st, sht, type, tag, object, index, value, t)
    success = false
    values = value.split(',')
    st.b.goto("mail.google.com")
      ele = st.b.input(:type => "email")
      if !ele.exists? then
        st.b.goto("https://mail.google.com/mail/?logout&hl=en&hlor")
        sleep 1
        ele = st.b.input(:type => "email")
        ele.send_keys(values[0])
        st.b.input(:type => "password").send_keys(values[1])
        st.b.input(:type => "submit").click()
        sleep 5
      else
        ele.send_keys(values[0])
        st.b.input(:type => "password").send_keys(values[1])
        st.b.input(:type => "submit").click()
        sleep 5
      end
      st.b.image(:alt => values[2]).click()
      st.b.link(:text => "Account").click()
      lastwindow = st.b.windows.count
      lastwindow = lastwindow -1
      st.b.windows[lastwindow].use
      st.b.link(:text => "Security").click()
      st.b.link(:text => "Review permissions").click()
      ele = st.b.input(:value => "Revoke Access")
      if ele.exists? then
        ele.click()
      end
      st.b.windows.last.close
      st.b.windows[lastwindow-1].use
      st.b.goto("https://mail.google.com/mail/?logout&hl=en&hlor")
      st.b.goto(values[3])
      st.b.link(:text => "Log In").click()
      st.b.link(:text => "Sign On with Google").click()
      st.b.input(:type => "email").send_keys(values[0])
      st.b.input(:type => "password").send_keys(values[1])
      st.b.input(:type => "submit").click()
      sleep 3
      st.b.button(:id => "submit_approve_access").click()
      sleep 5
      verifystring = 'Hello, ' + values[2]
      success = st.b.text.include? verifystring
      if success == true then
        sht.fr = 'Pass'
      else
        sht.fr = 'Fail'
	end
end

def  submitleads(st, pd, sht, type, tag, object, index, value, t)
  values = value.split(',')
  
  leadpage = Dir.pwd + '/LeadPage/index.html'
  st.b.goto('file:///' + leadpage)
  st.b.link(:text => "Submit Lead").click()
  #http://192.168.56.32:20001/lead
  st.b.input(:name => "url").send_keys('http://' + values[2] + '/lead')
  st.b.input(:name => "leadData.agentId").send_keys(values[3]) 
  if values[0].downcase != 'contactstable' then
    st.b.input(:name => "leadData.firstName").send_keys(values[0])
    st.b.input(:name => "leadData.lastName").send_keys(values[1])
    st.b.input(:name => "leadData.phone").send_keys("604-555-5555")
    st.b.input(:name => "leadData.email").send_keys("anarayan_" + values[0] + "_" + values[1] + "@tpolab.com")
    st.b.execute_script("window.alert = function() {}")
    st.b.execute_script("window.confirm = function() {return true}")
    st.b.button(:name => "go").click()
  else
    count =values[1].to_i
    i = 1;
    while i <= count do
      fn = 2 + rand(39)
      ln = 2 + rand(39)
      firstname = pd.Leads[fn][1]
      lastname = pd.Leads[ln][2]
      st.b.input(:name => "leadData.firstName").send_keys(firstname)
      st.b.input(:name => "leadData.lastName").send_keys(lastname)
      st.b.input(:name => "leadData.phone").send_keys("604-555-5555")
      st.b.input(:name => "leadData.email").send_keys("anarayan_" + firstname + "_" + lastname + "@tpolab.com")
      st.b.execute_script("window.alert = function() {}")
      st.b.execute_script("window.confirm = function() {return true}")
      st.b.button(:name => "go").click()
      st.b.input(:name => "leadData.firstName").send_keys [:shift, :home], :delete
      st.b.input(:name => "leadData.lastName").send_keys [:shift, :home], :delete
      st.b.input(:name => "leadData.phone").send_keys [:shift, :home], :delete
      st.b.input(:name => "leadData.email").send_keys [:shift, :home], :delete
      i += 1
    end
  end
end

def waitfor (t)
	sleep 1
end

def endtest (st)
	st.b.close
end
