def executecommand (st, pd, sht, command, objecttype, objecttag, objectval, objectindex, valuev, objecttag2, objectval2, t)
	puts "Executing line: #{t}"
    if (command).downcase == 'navigate' then
        navigate(st, sht, valuev, t)
	end
	if (command).downcase == 'refresh' then
		refresh(st, sht, t)
	end
	if (command).downcase == 'mnavigate' then
        mnavigate(mt, sht, valuev, t)
	end
	if command.downcase == 'm8isignout' then
		m8isignout(mt, sht, t)
	end
	if command.downcase == 'set' then
        settext(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t)
	end
	if command.downcase == 'radioset' then
		radioset(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t, objecttag2, objectval2)
	end
	if command.downcase == 'clickbutton' then
        clickbutton(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t, objecttag2, objectval2)
	end
	if command.downcase == 'clickimage' then
        clickimage(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t)
	end
	if command.downcase == 'clicklabel' then
		clicklabel(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t)
	end
	if command.downcase == 'verifypagetitle' then
		verifypagetitle(st, sht, valuev, t)
	end
	if command.downcase == 'verifypage' then
        verifypage(st, sht, valuev, t)
	end
	if command.downcase == 'verifynotonpage' then
		verifynotonpage(st, sht, valuev, t)
	end
	if command.downcase == 'verifytextfield' then
		verifytextfield(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t, objecttag2, objectval2)
	end
	if command.downcase == 'verifycontacttype' then
		verifycontacttype(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t, objecttag2, objectval2)
	end
	if command.downcase == 'verifycontactname' then
		verifycontactname(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t, objecttag2, objectval2)
	end
	if command.downcase == 'verifyinputfield' then
		verifyinputfield(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t, objecttag2, objectval2)
	end
	if command.downcase == 'clicksubmenu' then
		if objectval == 'TMKSetupWizard' then
			objectval = /Setup Wizard/i
		end
		clicksubmenu(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t, objecttag2, objectval2)
	end
	if command.downcase == 'clicklink' then
		clicklink(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t)
	end
	if command.downcase == 'clickspan' then
		clickspan(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t)
	end
	if command.downcase == 'clickinput' then
		clickinput(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t)
	end
	if command.downcase == 'selectlist' then
		selectlist(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t, objecttag2, objectval2)
	end
	if command.downcase == 'selectfile' then
		selectfile(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t, objecttag2, objectval2)
	end
	if command.downcase == 'clicktext' then
		clicktext(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t)
	end
	if command.downcase == 'switchto' then
		switchto(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t)
	end
	if command.downcase == 'closelatest' then
		closelatest(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t)
	end
	if command.downcase == 'waitforprocess' then
		waitforprocess(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t)
	end
	if command.downcase == 'waitforprocess2' then
		waitforprocess2(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t)
	end
	if command.downcase == 'iframeclick' then
		iframeclick(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t, objecttag2, objectval2)
	end
	if command.downcase == 'alert' then
		alert(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t, objecttag2, objectval2)
	end
	if command.downcase == 'malert' then
		malert(mt, sht, objecttype, objecttag, objectval, objectindex, valuev, t, objecttag2, objectval2)
	end
	if command.downcase == 'sethour' then
		sethour(t)
	end
	if command.downcase == 'gettime' then
		gettime(t)
	end
	if command.downcase == 'getdate' then
		getdate(valuev, t)
	end
	if command.downcase == 'verifytimestamp' then
		verifytimestamp(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t, objecttag2, objectval2)
	end
	if command.downcase == 'verifydate' then
		verifydate(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t, objecttag2, objectval2)
	end
	if command.downcase == 'clickgriditem' then
		clickgriditem(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t, objecttag2, objectval2)
	end
	if command.downcase == 'verifycontactstatus' then
		verifycontactstatus(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t, objecttag2, objectval2)
	end
	if command.downcase == 'cleanlogin' then
		cleanlogin(st, sht, objecttype, objecttag, objectval, objectindex, valuev, t)
	end
  if command.downcase == 'submitleads' then
    submitleads(st, pd, sht, objecttype, objecttag, objectval, objectindex,valuev, t)
  end
	if command.downcase =='wait' then
		waitfor(t)
		#puts "sleeping a sec, needed a pause?"
	end
	if command.downcase == 'endtest' then
		endtest(st)
	end
end
