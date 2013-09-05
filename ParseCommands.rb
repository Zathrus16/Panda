require 'roo'

class MultiArray
	attr_reader :hash
	def initialize
		@hash = {}
	end
	
	def [](key)
		hash[key] ||= {}
	end
	
	def rows
		hash.length
	end
	
	alias_method :length, :rows
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

class ParseData
  attr_accessor :Tests
  attr_accessor :Objects
  attr_accessor :Inputs
  attr_accessor :Execute
  attr_accessor :Leads
  attr_accessor :build
  attr_accessor :browser
  attr_accessor :icol
 
  
  def initialize(testname)
    xl   = Roo::Excelx.new(testname)
    xl2 = Roo::Excelx.new(testname)
    xl3 = Roo::Excelx.new(testname)
    xl4 = Roo::Excelx.new(testname)
    xl6 = Roo::Excelx.new(testname)
    xl.default_sheet = xl.sheets[0]
    xl2.default_sheet = xl2.sheets[1]						
    xl3.default_sheet = xl3.sheets[2]
    xl4.default_sheet = xl4.sheets[3]
    xl6.default_sheet = xl6.sheets[5]
    
    @Tests = MultiArray.new
    2.upto(xl.last_row) do |t|
      @Tests[t][1] = xl.cell(t,1)
      @Tests[t][2] = xl.cell(t,2)
      @Tests[t][3] = xl.cell(t,3)
      @Tests[t][4] = xl.cell(t,4)
      @Tests[t][5] = xl.cell(t,5)
      @Tests[t][6] = xl.cell(t,6)
    end

    @Objects = MultiArray.new
    2.upto(xl2.last_row) do |t|
      @Objects[t][1] = xl2.cell(t,1)
      @Objects[t][2] = xl2.cell(t,2)
      @Objects[t][3] = xl2.cell(t,3)
      @Objects[t][4] = xl2.cell(t,4)
      @Objects[t][5] = xl2.cell(t,5)
      @Objects[t][6] = xl2.cell(t,6)
      @Objects[t][7] = xl2.cell(t,7)
    end

    @Inputs = MultiArray.new
    2.upto(xl3.last_row) do |t|
      @Inputs[t][1] = xl3.cell(t,1)
      @Inputs[t][2] = xl3.cell(t,2)
      @Inputs[t][3] = xl3.cell(t,3)
      @Inputs[t][4] = xl3.cell(t,4)
      @Inputs[t][5] = xl3.cell(t,5)
      @Inputs[t][6] = xl3.cell(t,6)
      @Inputs[t][7] = xl3.cell(t,7)
      @Inputs[t][8] = xl3.cell(t,8)
    end

    @Execute = MultiArray.new
    2.upto(xl4.last_row) do |t|
      @Execute[t][1] = xl4.cell(t,1)
      @Execute[t][2] = xl4.cell(t,2)
      @Execute[t][3] = xl4.cell(t,3)
      @Execute[t][4] = xl4.cell(t,4)
    end
    
    @Leads = MultiArray.new
    2.upto(xl6.last_row) do |t|
      @Leads[t][1] = xl6.cell(t,1)
      @Leads[t][2] = xl6.cell(t,2)
    end
    
    d = @Tests[2][3]
    if d.downcase == 'localhost' then
      @icol = 2
    end
    if d.downcase == 'sqan' then
      @icol = 3
    end
    if d.downcase == 'staging' then
      @icol = 4
    end
    if d.downcase == 'sqac' then
      @icol = 5
    end
    if d.downcase == 'sqaf' then
      @icol = 6
    end
    if d.downcase == 'itgn' then
      @icol = 7
    end
    if d.downcase == 'itgf' then
      @icol = 8
    end
    if d.downcase == 'prod' then
      @icol = 9
    end

    @build = @Tests[3][3].downcase
    @browser = @Tests[4][3].downcase
  end
end

