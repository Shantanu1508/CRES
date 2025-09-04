using CRES.DataContract;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading;
using System.Threading.Tasks;


namespace CRES.BusinessLogic
{
    public class AIDynamicEntityUpdateLogic
    {
        Microsoft.Extensions.Configuration.IConfigurationSection Sectionroot = null;
        public void GetConfigSetting()
        {
            if (Sectionroot == null)
            {
                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                Sectionroot = root.GetSection("Application");
            }
        }
        //to call for AI dealname or credealid add/update
        public async Task InsertUpdateAIDealEntitiesAsync(DealDataContract DealDC, string userid)
        {
            try
            {
                GetConfigSetting();
                string AIApiAuthKey = Sectionroot.GetSection("AIApiAuthKey").Value;
                string BaseUrl = Sectionroot.GetSection("apiPath").Value;
                DateTime Starttime = DateTime.Now;
                HBOTLogic hbotLogic = new HBOTLogic();
                //insert new deal
                if (DealDC.DealID == new Guid("00000000-0000-0000-0000-000000000000"))
                {
                    string AIAddEntityApi = Sectionroot.GetSection("AIAddEntityApi").Value;
                    using (var client = new HttpClient())
                    {
                        client.BaseAddress = new Uri(BaseUrl);
                        client.DefaultRequestHeaders.Accept.Clear();
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                        AIRealTimeEntityDataContract EntityResult = new AIRealTimeEntityDataContract();
                        ArrayList dealidarr = new ArrayList();
                        ArrayList dealnamearr = new ArrayList();

                        // HTTP POST for credealid
                        HttpResponseMessage _dealidresponse = new HttpResponseMessage();
                        EntityResult.type = "DealID";
                        EntityResult.value = DealDC.CREDealID;
                        dealidarr.Add(DealDC.CREDealID);
                        EntityResult.synonym = dealidarr;
                        _dealidresponse = await client.PostAsJsonAsync(AIAddEntityApi + AIApiAuthKey, EntityResult);
                        if (_dealidresponse.IsSuccessStatusCode)
                        {
                            DateTime Endtime = DateTime.Now;
                            Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "DealIDAddEntityAPICalled"));
                            FirstThread.Start();
                        }
                        else
                        {
                            DateTime Endtime = DateTime.Now;
                            Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "DealIDAddEntityAPI - NotCalled"));
                            FirstThread.Start();
                        }

                        // HTTP POST for dealname
                        HttpResponseMessage _dealnameresponse = new HttpResponseMessage();
                        EntityResult.type = "DealName";
                        EntityResult.value = DealDC.DealName;
                        dealnamearr.Add(DealDC.DealName);
                        EntityResult.synonym = dealnamearr;

                        _dealnameresponse = await client.PostAsJsonAsync(AIAddEntityApi + AIApiAuthKey, EntityResult);
                        if (_dealnameresponse.IsSuccessStatusCode)
                        {
                            DateTime Endtime = DateTime.Now;
                            Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "DealNameAddEntityAPICalled"));
                            FirstThread.Start();
                        }
                        else
                        {
                            DateTime Endtime = DateTime.Now;
                            Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "DealNameAddEntityAPI - NotCalled"));
                            FirstThread.Start();
                        }
                    }

                    if (DealDC.notelist != null)
                    {
                        Thread NoteThread = new Thread(() => InsertUpdateAINoteEntitiesAsync(DealDC.notelist, userid));
                        NoteThread.Start();
                    }
                }// end for insert entity

                else
                {
                    // update dealname or credealid 
                    if (DealDC.CopyDealID == null)
                    {
                        string AIUpdateEntityApi = Sectionroot.GetSection("AIUpdateEntityApi").Value;
                        using (var client = new HttpClient())
                        {
                            AIRealTimeEntityDataContract EntityResult = new AIRealTimeEntityDataContract();
                            if (DealDC.OriginalCREDealID != DealDC.CREDealID)
                            {
                                client.BaseAddress = new Uri(BaseUrl);
                                client.DefaultRequestHeaders.Accept.Clear();
                                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                                ArrayList dealidarr = new ArrayList();


                                // HTTP POST for credealid
                                HttpResponseMessage _dealidresponse = new HttpResponseMessage();
                                EntityResult.type = "DealID";
                                EntityResult.original_entity = DealDC.OriginalCREDealID;
                                EntityResult.altered_entity = DealDC.CREDealID;
                                //dealidarr.Add(DealDC.OriginalCREDealID);
                                dealidarr.Add(DealDC.CREDealID);
                                EntityResult.synonym = dealidarr;
                                _dealidresponse = await client.PostAsJsonAsync(AIUpdateEntityApi + AIApiAuthKey, EntityResult);
                                if (_dealidresponse.IsSuccessStatusCode)
                                {
                                    DateTime Endtime = DateTime.Now;
                                    //insert start and end time 
                                    Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "UpdateDealIDEntityAPICalled"));
                                    FirstThread.Start();
                                }
                                else
                                {
                                    DateTime Endtime = DateTime.Now;
                                    //insert start and end time 
                                    Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "UpdateDealIDEntityAPI - NotCalled"));
                                    FirstThread.Start();
                                }
                            }

                            // HTTP POST for dealname
                            if (DealDC.OriginalDealName != DealDC.DealName)
                            {
                                ArrayList dealnamearr = new ArrayList();
                                HttpResponseMessage _dealnameresponse = new HttpResponseMessage();
                                EntityResult.type = "DealName";
                                EntityResult.original_entity = DealDC.OriginalDealName;
                                EntityResult.altered_entity = DealDC.DealName;
                                //dealnamearr.Add(DealDC.OriginalDealName);
                                dealnamearr.Add(DealDC.DealName);
                                EntityResult.synonym = dealnamearr;

                                _dealnameresponse = await client.PostAsJsonAsync(AIUpdateEntityApi + AIApiAuthKey, EntityResult);
                                if (_dealnameresponse.IsSuccessStatusCode)
                                {
                                    DateTime Endtime = DateTime.Now;
                                    //insert start and end time 
                                    Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "UpdateDealNameEntityAPICalled"));
                                    FirstThread.Start();
                                    Uri aientityUrl = _dealnameresponse.Headers.Location;
                                }
                                else
                                {
                                    DateTime Endtime = DateTime.Now;
                                    //insert start and end time 
                                    Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "UpdateDealNameEntityAPI - NotCalled"));
                                    FirstThread.Start();
                                }
                            }
                        }

                    }
                } // end for update entity

            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.AI_Assistant.ToString(), "Error occurred  while saving deal(AI Entity insert/update): Deal ID " + DealDC.CREDealID, DealDC.DealID.ToString(), userid, ex.TargetSite.Name.ToString(), "", ex);
            }
        }

        //Delete AI entity
        public async Task DeleteAIDealEntitiesAsync(DeleteModuleDataContract moduleDc, string userid)
        {
            try
            {
                GetConfigSetting();
                DateTime Starttime = DateTime.Now;
                HBOTLogic hbotLogic = new HBOTLogic();
                string AIApiAuthKey = Sectionroot.GetSection("AIApiAuthKey").Value;
                string BaseUrl = Sectionroot.GetSection("apiPath").Value;
                string AIDeleteEntityApi = Sectionroot.GetSection("AIDeleteEntityApi").Value;
                DealLogic _deallogic = new DealLogic();
                DataTable dt = new DataTable();
                if (moduleDc.ModuleName == "Deal" || moduleDc.ModuleName == "Note")
                {
                    dt = _deallogic.DeleteDealandNoteAIEntity(new Guid(userid), moduleDc.ModuleName, moduleDc.ModuleID);
                }
                if (dt.Rows.Count > 0)
                {
                    using (var client = new HttpClient())
                    {
                        client.BaseAddress = new Uri(BaseUrl);
                        client.DefaultRequestHeaders.Accept.Clear();
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                        AIRealTimeEntityDataContract EntityResult = new AIRealTimeEntityDataContract();

                        if (moduleDc.ModuleName == "Deal")
                        {
                            // HTTP POST for credealid
                            HttpResponseMessage _dealidresponse = new HttpResponseMessage();
                            EntityResult.type = "DealID";
                            EntityResult.value = Convert.ToString(dt.Rows[0]["CREDealID"]);

                            _dealidresponse = await client.PostAsJsonAsync(AIDeleteEntityApi + AIApiAuthKey, EntityResult);
                            if (_dealidresponse.IsSuccessStatusCode)
                            {
                                DateTime Endtime = DateTime.Now;
                                Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "DeleteDealIDEntityAPICalled"));
                                FirstThread.Start();
                            }
                            else
                            {
                                DateTime Endtime = DateTime.Now;
                                Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "DeleteDealIDEntityAPI - NotCalled"));
                                FirstThread.Start();
                            }

                            // HTTP POST for dealname
                            HttpResponseMessage _dealnameresponse = new HttpResponseMessage();
                            EntityResult.type = "DealName";
                            EntityResult.value = Convert.ToString(dt.Rows[0]["DealName"]);

                            _dealnameresponse = await client.PostAsJsonAsync(AIDeleteEntityApi + AIApiAuthKey, EntityResult);
                            if (_dealnameresponse.IsSuccessStatusCode)
                            {
                                DateTime Endtime = DateTime.Now;
                                Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "DeleteDealnameEntityAPICalled"));
                                FirstThread.Start();
                            }
                            else
                            {
                                DateTime Endtime = DateTime.Now;
                                Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "DeleteDealnameEntityAPI - NotCalled"));
                                FirstThread.Start();
                            }

                            // for crenoteid's
                            foreach (DataRow dr in dt.Rows)
                            {

                                HttpResponseMessage _noteidresponse = new HttpResponseMessage();
                                EntityResult.type = "NoteID";
                                EntityResult.value = Convert.ToString(dr["CRENoteID"]);

                                _noteidresponse = await client.PostAsJsonAsync(AIDeleteEntityApi + AIApiAuthKey, EntityResult);
                                if (_noteidresponse.IsSuccessStatusCode)
                                {
                                    DateTime Endtime = DateTime.Now;
                                    Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "DeleteNoteIDEntityAPICalled"));
                                    FirstThread.Start();
                                }
                                else
                                {
                                    DateTime Endtime = DateTime.Now;
                                    Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "DeleteNoteIDEntityAPI - NotCalled"));
                                    FirstThread.Start();
                                }
                            }
                        }
                        if (moduleDc.ModuleName == "Note")
                        {
                            HttpResponseMessage _noteidresponse = new HttpResponseMessage();
                            EntityResult.type = "NoteID";
                            EntityResult.value = Convert.ToString(dt.Rows[0]["CRENoteID"]);

                            _noteidresponse = await client.PostAsJsonAsync(AIDeleteEntityApi + AIApiAuthKey, EntityResult);
                            if (_noteidresponse.IsSuccessStatusCode)
                            {
                                DateTime Endtime = DateTime.Now;
                                Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "DeleteNoteEntityAPICalled"));
                                FirstThread.Start();
                            }
                            else
                            {
                                DateTime Endtime = DateTime.Now;
                                Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "DeleteNoteEntityAPI - NotCalled"));
                                FirstThread.Start();
                            }
                        }
                    }

                }// end for delete entity
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.AI_Assistant.ToString(), "Error occured in Delete entity for module(AI entity delete)" + moduleDc.ModuleName, "", userid.ToString(), ex.TargetSite.Name.ToString(), "", ex);
            }
        }

        //to call for AI notename or crenoteid add/update
        public async Task InsertUpdateAINoteEntitiesAsync(List<NoteDataContract> _noteDC, string userid)
        {
            try
            {
                GetConfigSetting();
                DateTime Starttime = DateTime.Now;
                HBOTLogic hbotLogic = new HBOTLogic();
                string AIApiAuthKey = Sectionroot.GetSection("AIApiAuthKey").Value;
                string BaseUrl = Sectionroot.GetSection("apiPath").Value;
                string AIAddEntityApi = Sectionroot.GetSection("AIAddEntityApi").Value;
                //insert new deal
                foreach (var note in _noteDC)
                {
                    if (note.NoteId == "00000000-0000-0000-0000-000000000000")
                    {
                        ArrayList noteidarr = new ArrayList();
                        ArrayList notenamearr = new ArrayList();
                        using (var client = new HttpClient())
                        {
                            client.BaseAddress = new Uri(BaseUrl);
                            client.DefaultRequestHeaders.Accept.Clear();
                            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                            AIRealTimeEntityDataContract EntityResult = new AIRealTimeEntityDataContract();

                            // HTTP POST for crenoteid
                            HttpResponseMessage _noteidresponse = new HttpResponseMessage();
                            EntityResult.type = "NoteID";
                            EntityResult.value = note.CRENoteID;
                            noteidarr.Add(note.CRENoteID);

                            EntityResult.synonym = noteidarr;

                            _noteidresponse = await client.PostAsJsonAsync(AIAddEntityApi + AIApiAuthKey, EntityResult);
                            if (_noteidresponse.IsSuccessStatusCode)
                            {
                                DateTime Endtime = DateTime.Now;
                                Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "AddNoteIDEntityAPICalled"));
                                FirstThread.Start();
                            }
                            else
                            {
                                DateTime Endtime = DateTime.Now;
                                Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "AddNoteIDEntityAPI - NotCalled"));
                                FirstThread.Start();
                            }
                            //// HTTP POST for notename
                            HttpResponseMessage _notenameresponse = new HttpResponseMessage();
                            EntityResult.type = "NoteName";
                            EntityResult.value = note.Name;
                            notenamearr.Add(note.Name);
                            EntityResult.synonym = notenamearr;

                            _notenameresponse = await client.PostAsJsonAsync(AIAddEntityApi + AIApiAuthKey, EntityResult);
                            if (_notenameresponse.IsSuccessStatusCode)
                            {
                                DateTime Endtime = DateTime.Now;
                                Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "AddNoteNameEntityAPICalled"));
                                FirstThread.Start();
                            }
                            else
                            {
                                DateTime Endtime = DateTime.Now;
                                Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "AddNoteNameEntityAPI - NotCalled"));
                                FirstThread.Start();
                            }
                        }

                    }// end for insert entity
                    else
                    {
                        //update noteid and notename
                        string AIUpdateEntityApi = Sectionroot.GetSection("AIUpdateEntityApi").Value;
                        using (var client = new HttpClient())
                        {
                            AIRealTimeEntityDataContract EntityResult = new AIRealTimeEntityDataContract();
                            if (note.OriginalCRENoteID != note.CRENoteID)
                            {

                                client.BaseAddress = new Uri(BaseUrl);
                                client.DefaultRequestHeaders.Accept.Clear();
                                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                                ArrayList noteidarr = new ArrayList();

                                // HTTP POST for crenoteid
                                HttpResponseMessage _noteidresponse = new HttpResponseMessage();
                                EntityResult.type = "NoteID";
                                EntityResult.original_entity = note.OriginalCRENoteID;
                                EntityResult.altered_entity = note.CRENoteID;
                                // noteidarr.Add(note.OriginalCRENoteID);
                                noteidarr.Add(note.CRENoteID);
                                EntityResult.synonym = noteidarr;
                                _noteidresponse = await client.PostAsJsonAsync(AIUpdateEntityApi + AIApiAuthKey, EntityResult);
                                if (_noteidresponse.IsSuccessStatusCode)
                                {
                                    DateTime Endtime = DateTime.Now;
                                    Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "UpdateNoteIDEntityAPICalled"));
                                    FirstThread.Start();
                                }
                                else
                                {
                                    DateTime Endtime = DateTime.Now;
                                    Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "UpdateNoteIDEntityAPI - NotCalled"));
                                    FirstThread.Start();
                                }
                            }

                            // HTTP POST for notename
                            if (note.OriginalNoteName != note.Name)
                            {
                                ArrayList notenamearr = new ArrayList();
                                HttpResponseMessage _notenameresponse = new HttpResponseMessage();
                                EntityResult.type = "NoteName";
                                EntityResult.value = note.Name;
                                notenamearr.Add(note.Name);
                                EntityResult.synonym = notenamearr;
                                _notenameresponse = await client.PostAsJsonAsync(AIAddEntityApi + AIApiAuthKey, EntityResult);
                                if (_notenameresponse.IsSuccessStatusCode)
                                {
                                    DateTime Endtime = DateTime.Now;
                                    Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "UpdateNoteNameEntityAPICalled"));
                                    FirstThread.Start();
                                }
                                else
                                {
                                    DateTime Endtime = DateTime.Now;
                                    Thread FirstThread = new Thread(() => hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, "UpdateNoteNameEntityAPI - NotCalled"));
                                    FirstThread.Start();
                                }
                            }
                        }
                    }// end for update entity
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.AI_Assistant.ToString(), "Error occurred  while saving note(AI Entity insert/update): Deal ID " + _noteDC[0].CRENoteID, _noteDC[0].NoteId.ToString(), userid, ex.TargetSite.Name.ToString(), "", ex);
            }
        }

        public async Task InsertUpdateAIEntitiesAsync(string entity_type, string entity_names, string userid, string addorUpdate, string originalentitynames)
        {
            try
            {

                GetConfigSetting();
                DateTime Starttime = DateTime.Now;
                HBOTLogic hbotLogic = new HBOTLogic();
                string AIApiAuthKey = Sectionroot.GetSection("AIApiAuthKey").Value;
                string BaseUrl = Sectionroot.GetSection("apiPath").Value;
                string AIEntityApi = "";

                ArrayList noteidarr = new ArrayList();
                ArrayList notenamearr = new ArrayList();

                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(BaseUrl);
                    client.DefaultRequestHeaders.Accept.Clear();
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    AIRealTimeEntityDataContract EntityResult = new AIRealTimeEntityDataContract();

                    HttpResponseMessage _noteidresponse = new HttpResponseMessage();
                    if (addorUpdate == "Insert")
                    {
                        AIEntityApi = Sectionroot.GetSection("AIAddEntityApi").Value;
                        EntityResult.value = entity_names;
                    }
                    else if (addorUpdate == "Update")
                    {
                        AIEntityApi = Sectionroot.GetSection("AIUpdateEntityApi").Value;

                        EntityResult.original_entity = originalentitynames;
                        EntityResult.altered_entity = entity_names;
                    }
                    EntityResult.type = entity_type;
                    noteidarr.Add(entity_names);
                    EntityResult.synonym = noteidarr;

                    _noteidresponse = await client.PostAsJsonAsync(AIEntityApi + AIApiAuthKey, EntityResult);
                    if (_noteidresponse.IsSuccessStatusCode)
                    {
                        DateTime Endtime = DateTime.Now;
                        hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, addorUpdate + " " + entity_type + " Called");
                    }
                    else
                    {
                        DateTime Endtime = DateTime.Now;
                        hbotLogic.InsertAIApiStartandEndTime(new Guid(userid), Starttime, Endtime, addorUpdate + " " + entity_type + " NotCalled");
                    }
                }

            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.AI_Assistant.ToString(), "Error occurred  while saving note(AI Entity insert/update): Deal ID " + entity_names, entity_names, userid, ex.TargetSite.Name.ToString(), "", ex);
            }
        }

    }
}
