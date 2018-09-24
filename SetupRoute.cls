global class SetupRoute {
    public string acList {
        get;
        set;
    }

    global list < Visit__c > vtList {
        get;
        set;
    }
    public string userlist {
        get;
        set;
    }
    public string leadlist{
        get;
        set;
    }

    public SetupRoute() {
        try {
            list < User > ulist = [select id, Name, Phone, Email from user where username =: userInfo.getUserName()];
            userlist = JSON.serialize(ulist);
            list < Account > acclist = [select id, name, Phone, website, (select contact.Name, contact.Department, contact.Id from contacts), BillingCity, BillingStreet, BillingState, BillingCountry, Account_Latitude__c, Account_Longitude__c from Account where OwnerId =: UserInfo.getUserID()];
            system.debug('Acc List : ' + acclist);
            if (!acclist.isEmpty()) {
                acList = JSON.serialize(acclist);
                system.debug('LatlongList : ' + acList);
            }
            list<lead> ldlist = [select id, name, City, Street, Country, State, Email, Phone, Company, Lead_Latitude__c, Industry, Lead_Longitude__c from lead where OwnerId =: UserInfo.getUserID()];
            if(ldlist !=null){
                leadlist = JSON.serialize(ldlist);
            }
        } catch (Exception e) {
            system.debug('Error in SetupRoute Class : ' + e.getMessage());
            system.debug('Error in line no : ' + e.getCause());
        }
    }

    @RemoteAction
    public static void createVisits(string json_data) {
        list < visit__c > vtList = new list < Visit__c > ();
        try {
            list < string > dateday = new list < string > ();
            list < datetime > dateList = new list < datetime > ();
            list < map < string, object >> IdList = new list < map < String, object >> ();
            list < Visit__c > vt_List = new list < Visit__c > ();
            list < object > mapData = (list < object > ) JSON.deserializeUntyped(json_data);
            system.debug('MAp Data : ' + mapData);
            list < map < string, datetime >> daymap = new list < map < string, datetime >> ();

            for (object vt: mapData) {
                map < string, object > data = (map < string, object > ) vt;
                if (data.get('AccountId') != null) {
                    map < string, object > a2 = new map < string, object > ();
                    for (String Sid: data.keySet()) {
                        a2.put(Sid, data.get(Sid));
                    }
                    IdList.add(a2);
                   system.debug('Data List :' + IdList); 
                } else if (data.get('Enddate') != null) {
                    string[] SdateArr = data.get('Startdate').toString().split('/');
                    datetime Sdate = datetime.newInstance(date.newInstance(integer.valueOf(SdateArr[2]), Integer.valueOf(SdateArr[1]), Integer.valueOf(SdateArr[0])), time.newInstance(0, 0, 0, 0));
                    String[] EdateArr = data.get('Enddate').tostring().split('/');
                    datetime Edate = datetime.newInstance(date.newInstance(integer.valueOf(EdateArr[2]), Integer.valueOf(EdateArr[1]), Integer.valueOf(EdateArr[0])), time.newInstance(0, 0, 0, 0));
                    system.debug('Start date and end date : ' + Sdate + '  ' + Edate);
                    while (Sdate <= Edate) {
                        map < string, datetime > a = new map < string, datetime > {
                            Sdate.format('EEEE') => Sdate
                        };
                        daymap.add(a);
                        Sdate = Sdate.addDays(1);
                    }
                    system.debug('Date array with DayName : ' + daymap);
                    for (string s: data.keySet()) {
                        if (s != 'Enddate' && s != 'Startdate' && data.get(s) != 'false') {
                            dateday.add(s);
                        }
                    }
                    system.debug(dateday);
                    for (map < string, datetime > dmap: daymap) {
                        for (integer i = 0; i < dateday.size(); i++) {
                            if (dmap.containskey(dateday[i])) {
                                dateList.add(dmap.get(dateday[i]));
                            }
                        }
                    }

                } 
            }
            system.debug('DateList kya aagyi : ' + dateList);
            for (map < string, object > visit: IdList) {
                for (datetime dt: dateList) {
                    Visit__c newVisit = new Visit__c();
                    if(visit.get('AccountId').toString().startsWith('001')){
                        newVisit.Account__c = visit.get('AccountId').toString();
                    }else{
                      newVisit.Lead__c = visit.get('AccountId').toString();  
                    }
                    system.debug('Account : '+visit.get('AccountId').toString());
                    newVisit.Visit_Date__c = dt.date();
                    if(visit.get('ContactId').tostring().startsWith('003')){
                        newVisit.Contact__c = visit.get('ContactId').tostring();
                    }
                    vtList.add(newVisit);
                }
            }
               system.debug('Visit List : ' + vtList);
               insert vtList;
            } catch (exception e) {
                system.debug('Error in creating visit : ' + e.getMessage());
                system.debug('error line no : ' + e.getLineNumber());
                system.debug('Error Cause : ' + e.getCause());
            }
            // return vtList;
        }	


    }