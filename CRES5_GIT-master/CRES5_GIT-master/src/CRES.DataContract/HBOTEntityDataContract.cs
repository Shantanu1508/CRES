using System.Collections;

namespace CRES.DataContract
{
    public class HBOTEntityDataContract
    {
        public string entity_type { get; set; }
        public string entity_names { get; set; }
        public string synonyms { get; set; }
    }

    public class AIRealTimeEntityDataContract
    {
        public string type { get; set; }
        public string value { get; set; }
        public string original_entity { get; set; }
        public string altered_entity { get; set; }
        public ArrayList synonym { get; set; }
    }
}