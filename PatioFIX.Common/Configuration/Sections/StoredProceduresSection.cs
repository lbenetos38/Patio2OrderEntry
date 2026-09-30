using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PatioFIX.Common.Configuration
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

    public class EvaluatorsSection
    {
        public string SectionName { get; } = "Evaluators";

        public string Ignored_Create { get; set; } = "dbo.fxodl_ignored_Create";
        public string ConfirmCancel_Create { get; set; } = "dbo.fxodl_confirmcancel_Create";
        public string ConfirmChange_Create { get; set; } = "dbo.fxodl_confirmchange_Create";
        public string ConfirmOrder_Create { get; set; } = "dbo.fxodl_confirmorder_Create";
        public string ConfirmOrderEdit_Create { get; set; } = "dbo.fxodl_confirmorderedit_Create";
        public string CreditLimitInformation_Create { get; set; } = "dbo.fxodl_creditlimitinformation_Create";
        public string ExchangeNotes_Create { get; set; } = "dbo.fxodl_exchangenotes_Create";
        public string OrderMarketStatus_Create { get; set; } = "dbo.fxodl_ordermarketstatus_Create";
        public string Reject_Create { get; set; } = "dbo.fxodl_reject_Create";
        public string SecurityPrices_Create { get; set; } = "dbo.fxodl_securityprices_Create";
        public string Trades_Create { get; set; } = "dbo.fxodl_trades_Create";
        public string TradesCaptureReports_Create { get; set; } = "dbo.fxodl_tradescapturereports_Create2";
        public string Orders_UpdateStatus { get; set; } = "dbo.fxodl_Orders_UpdateStatuses";
        public string Orders_UpdateProcessCode { get; set; } = "dbo.fxodl_Orders_UpdateProcessCode";

        public EvaluatorsSection(IConfigurationSection root, bool required = true)
        {
            var section = root.GetSection(this.SectionName);
            if (section.Exists())
            {
                var value = section["Ignored_Create"];
                if (string.IsNullOrWhiteSpace(value) == false)
                    this.Ignored_Create = value;

                value = section["ConfirmCancel_Create"];
                if (string.IsNullOrWhiteSpace(value) == false)
                    this.ConfirmCancel_Create = value;

                value = section["ConfirmChange_Create"];
                if (string.IsNullOrWhiteSpace(value) == false)
                    this.ConfirmChange_Create = value;

                value = section["ConfirmOrder_Create"];
                if (string.IsNullOrWhiteSpace(value) == false)
                    this.ConfirmOrder_Create = value;

                value = section["ConfirmOrderEdit_Create"];
                if (string.IsNullOrWhiteSpace(value) == false)
                    this.ConfirmOrderEdit_Create = value;

                value = section["CreditLimitInformation_Create"];
                if (string.IsNullOrWhiteSpace(value) == false)
                    this.CreditLimitInformation_Create = value;

                value = section["ExchangeNotes_Create"];
                if (string.IsNullOrWhiteSpace(value) == false)
                    this.ExchangeNotes_Create = value;

                value = section["OrderMarketStatus_Create"];
                if (string.IsNullOrWhiteSpace(value) == false)
                    this.OrderMarketStatus_Create = value;

                value = section["Reject_Create"];
                if (string.IsNullOrWhiteSpace(value) == false)
                    this.Reject_Create = value;

                value = section["SecurityPrices_Create"];
                if (string.IsNullOrWhiteSpace(value) == false)
                    this.SecurityPrices_Create = value;

                value = section["Trades_Create"];
                if (string.IsNullOrWhiteSpace(value) == false)
                    this.Trades_Create = value;

                value = section["TradesCaptureReports_Create"];
                if (string.IsNullOrWhiteSpace(value) == false)
                    this.TradesCaptureReports_Create = value;

                value = section["Orders_UpdateStatus"];
                if (string.IsNullOrWhiteSpace(value) == false)
                    this.Orders_UpdateStatus = value;

                value = section["Orders_UpdateProcessCode"];
                if (string.IsNullOrWhiteSpace(value) == false)
                    this.Orders_UpdateProcessCode = value;
            }
            else if (required)
            {
                throw new ArgumentException($"There is no {section.Path} section but is a required one");
            }
        }
    }
}
