public class JSON2Apex {
	public Solution solution{ get; set; }
    
    public class Solution {
        public routes[] routes{ get; set; }
        public Unassigned unassigned{get; set;}
    }
    public class routes {
     public List<activities> activities{ get; set; }
    }
    
    public class activities {
     public String type{ get; set; }
     public String location_id{ get; set; }
     public String id{ get; set; }
     public address address{ get; set; }
    }
    public class address{
        public String location_id{ get; set; }
        public String lat{ get; set; }
        public String lon{ get; set; }
    }
    public class Unassigned{
        public List<String> services{ get; set; }
    }

}