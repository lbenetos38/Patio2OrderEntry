using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PatioFIX.Common.Configuration.Sections
{
    public class StoredProceduresSection
    {
        /// <summary>
        /// 
        /// </summary>
        public string SectionName { get; } = "StoredProcedures";

        public string GetOutboundMessages { get; set; } = "dbo.fxodl_broker_GetOutboundMessages";
        public string SetOrderAsSent { get; set; } = "dbo.fxodl_broker_SetOrderAsSent";
        public string SetChangeAsSent { get; set; } = "dbo.fxodl_broker_SetChangeAsSent";
        public string SetCancelAsSent { get; set; } = "dbo.fxodl_broker_SetCancelAsSent";

        public StoredProceduresSection(IConfigurationSection root, bool required = true)
        {
            var section = root.GetSection(this.SectionName);  
            if (section.Exists())
            {
                var value = section["GetOutboundMessages"];
                if (string.IsNullOrWhiteSpace(value))
                    this.GetOutboundMessages = value;
                else
                    throw new ArgumentNullException(nameof(value));

                value = section["SetOrderAsSent"];
                if (string.IsNullOrWhiteSpace(value))
                    this.SetOrderAsSent = value;
                else
                    throw new ArgumentNullException(nameof(value));

                value = section["SetChangeAsSent"];
                if (string.IsNullOrWhiteSpace(value))
                    this.SetChangeAsSent = value;
                else
                    throw new ArgumentNullException(nameof(value));

                value = section["SetCancelAsSent"];
                if (string.IsNullOrWhiteSpace(value))
                    this.SetCancelAsSent = value;
                else
                    throw new ArgumentNullException(nameof(value));
            }
            else
            {
                if (required)
                {
                    throw new ArgumentException($"There is no {section.Path} section but is a required one");
                }
            }
        }

        internal void Dump()
        {
            Console.WriteLine($"[{this.SectionName}]");
            Console.WriteLine($"GetOutboundMessages: {this.GetOutboundMessages}");
            Console.WriteLine($"SetOrderAsSent: {this.SetOrderAsSent}");
            Console.WriteLine($"SetChangeAsSent: {this.SetChangeAsSent}");
            Console.WriteLine($"SetCancelAsSent: {this.SetCancelAsSent}");
        }   
    }
}
