require 'watir'
require 'fileutils'
require 'win32ole'

require_relative 'webcommands.rb'
require_relative 'executecommand.rb'
require_relative 'parsecommands.rb'


@testname =  Dir.pwd + '/Panda.xlsx'
pd = ParseData.new(@testname)
rundate = (Time.now.strftime("%Y-%m-%d")).to_s
@savefile = (Dir.pwd + "/Panda" + rundate + ".xlsx")
@savefile["/"] = "\\"
@Started = File.exists?(@savefile)
sht = UpdateSheet.new(@testname, @savefile, @Started)
st = SetupTest.new(pd.browser)
StartTime = Time.now
puts StartTime

# @PreviousValue = sht.sheet.Cells(646,6).value
# if @PreviousValue != nil then
	# puts @PreviousValue
	# @PreviousValues = @PreviousValue.split(":")
	# @PreviousMin = @PreviousValues[0].to_f
	# @PreviousSec = @PreviousValues[1].to_f
	# @PreviousTotal = @PreviousMin * 60 + @PreviousSec
# end

# puts @PreviousTotal

for e in 3..pd.Execute.length+1
	run = (pd.Execute[e][3]).to_s
	if (run).downcase == 'y'
		@section = pd.Execute[e][2]
		if @section != 99 then
			ar = sht.execute.Cells(@section+1,5).value
		end
		if ar != 'Run' then
			for t in 5..pd.Tests.length+1
				id = pd.Tests[t][2]
				if id == @section and (pd.Tests[t][1]).downcase == 'y' then
					@objectindex = nil
					@output = nil
					@value = nil
					@objecttype = nil
					sht.fr = nil
					#get the command to be executed
					@command = (pd.Tests[t][3]).clone
					#get the object values
					if pd.Tests[t][4] != nil then
						search = (pd.Tests[t][4]).clone.downcase
						for o in 2..pd.Objects.length+1
							if (pd.Objects[o][1]).downcase == search then
								if pd.Objects[o][2] != nil then
									@objecttype = (pd.Objects[o][2]).clone
								end
								if pd.Objects[o][3] != nil then
									@objecttag = (pd.Objects[o][3]).clone
								end
								if pd.Objects[o][4] != nil then
									@objectval = (pd.Objects[o][4]).clone
								end
								if pd.Objects[o][5] != nil then
									@objectindex = (pd.Objects[o][5])
								end
								if pd.Objects[o][6] != nil then
									@objecttag2 = (pd.Objects[o][6]).clone
								end
								if pd.Objects[o][7] != nil then
									@objectvalue2 = (pd.Objects[o][7]).clone
								end
								break
							end
						end
					end
					case @objecttag
						when 'id'
							@objecttag = :id
						when 'name'
							@objecttag = :name
						when 'class'
							@objecttag = :class
						when 'xpath'
							@objecttag = :xpath
						when 'link'
							@objecttag = :link
						when 'css'
							@objecttag = :css
						when 'title'
							@objecttag = :title
						when 'text'
							@objecttag = :text
						when 'alt'
							@objecttag = :alt
					end
					case @objecttag2
						when 'id'
							@objecttag2 = :id
						when 'name'
							@objecttag2 = :name
						when 'class'
							@objecttag2 = :class
						when 'xpath'
							@objecttag2 = :xpath
						when 'link'
							@objecttag2 = :link
						when 'css'
							@objecttag2 = :css
						when 'title'
							@objecttag2 = :title
						when 'text'
							@objecttag2 = :text
						when 'alt'
							@objecttag2 = :alt
					end
					#get the value to be used
					if pd.Tests[t][5] != nil then
						search = (pd.Tests[t][5]).downcase
						for i in 2..pd.Inputs.length+1
							if (pd.Inputs[i][1]).downcase == search then
								if pd.Inputs[i][pd.icol] == nil then
									@value = pd.Inputs[i][2]
								else
									@value = pd.Inputs[i][pd.icol]
								end
								break
							end
						end
					end
					if pd.Tests[t][6] != nil then
						@output = (pd.Tests[t][6]).to_i
					end
					begin
            executecommand(st, pd, sht, @command, @objecttype, @objecttag, @objectval, @objectindex, @value, @objecttag2, @objectvalue2, t)
          rescue => e
						sht.excel.quit
						st.b.close
						raise
					end
					if sht.fr != nil and @output != nil then
						sht.sheet.Cells(@output,6).value = sht.fr
						sht.sheet.Cells(@output,7).value = pd.browser
						sht.sheet.Cells(@output,8).value = "Ruby"
						sht.sheet.Cells(@output,9).value = rundate
						sht.sheet.Cells(@output,10).value = pd.build
						if @Started == true then
							sht.workbook.Save
						else	
							sht.workbook.SaveAs(@savefile)
							@Started = true
						end
					end
				end
			end
		end
		# @SectionTime = Time.now
		# @SectionElapsed = @SectionTime.to_f - StartTime.to_f
		# if @PreviousTotal != nil then
			# @TotalElapsed = @SectionElapsed + @PreviousTotal
		# else
			# @TotalElapsed = @SectionElapsed
		# end
		# @m, @s = @TotalElapsed.divmod 60.0
		# @ct = ("%d:%04.2f"%[@m.to_i, @s])
		# puts @ct
		# sht.sheet.Cells(646,6).value = @ct
		# if @section != 99  and run.downcase == 'y' then
			# sht.execute.Cells(@section +1,5).value = "Run"
		# end
		# remove_instance_variable(:@SectionTime)
		# remove_instance_variable(:@SectionElapsed)
		# remove_instance_variable(:@TotalElapsed)
		# remove_instance_variable(:@m)
		# remove_instance_variable(:@s)
		# remove_instance_variable(:@ct)
	end
end
sht.workbook.save
sht.workbook.close
sht.excel.quit

