require 'httparty'

# A fancy lib that uses v2 of the Nike+ API
# https://github.com/eagereyes/eagerfeet/blob/master/app-eagerfeet.js#L112

# A Ruby lib that uses Nokogiri to parse the XML (might be faster to use, since HTTParty auto-parses the XML into JSON)
# https://github.com/holman/fatigue/blob/master/lib/fatigue/nike.rb

# Test urls
# http://nikerunning.nike.com/nikeplus/v1/services/widget/get_public_user_data.jsp?userID=1759895612
# http://nikerunning.nike.com/nikeplus/v2/services/app/run_list.jsp?userID=1759895612
# http://nikerunning.nike.com/nikeplus/v1/services/widget/get_public_run_list.jsp?userID=1759895612
# http://nikerunning.nike.com/nikeos/p/nikeplus/en_GB/plus/#//runs/history/417671841/all/allRuns/
# http://nikerunning.nike.com/nikeplus/v1/services/widget/get_public_run_list.jsp?userID=751872695

# TODO: Create a sync job, add import_id, import_source and a (combined) index for those
class NikePlus
  include HTTParty
  base_uri 'https://nikerunning.nike.com'
  
  def self.get_runs(user_id)
    r = NikePlus.get('/nikeplus/v2/services/app/run_list.jsp?userID=' + user_id)
    if r['plusService']['status'] == 'success'
      for run in r['plusService']['runList']['run']
        p run['id']
        p Time.iso8601 run['startTime']
        p run['calories']
        p run['duration']
        p run['distance'] # km assumed
      end
    end
  end
end