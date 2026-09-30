using System.Security.Policy;

namespace PatioFIX.Common
{
    /// <summary>
    /// EuroNext FIX Field Tag Values
    /// </summary>/
    public static partial class Tags
    {
        /* Account Code - Indicates the account type for which the order is entered. 
         * For example, an order can be entered for a client account, a house account or a liquidity provider account.
            1 = Client
            2 = House
            4 = RO
            5 = Assigned Broker
            6 = Liquidity Provider
            7 = Related Party
            8 = Structured Product Market Maker
        */

        public const int AccountCode = 6399;

        // Exchange Market Model (EMM) specific tags
        /*
            1 = Cash and Derivative Central Order Book(COB)
            2 = NAV Trading Facility
            3 = SATURN On-Exchange Off-Book
            4 = Derivative Wholesales
            5 = Cash On Exchange Off book
            6 = Euronext off-exchange trade reports
            7 = Derivative On Exchange Off book
            8 = ETF MTF -NAV Central Order Book
            9 = Listed-not traded
            15 = Delta Neutral Contingency Leg
            99 = Not Applicable(For indices and iNAV)
        */

        public const int EMM = 20020;

        public const int CancelOnDisconnect = 21018;

        public const int OEPartitionID = 21019;
        public const int QueueingIndicator = 21020;
        public const int LogicalAccess = 21021;
        public const int SoftwareProvider = 21050;

    }
}
