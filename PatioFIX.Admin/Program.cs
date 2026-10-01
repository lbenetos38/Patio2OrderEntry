using PatioFIX.Common;
using System;
using System.ServiceProcess;
using System.Windows.Forms;

namespace PatioFIX.Admin
{
    /// <summary>
    /// 
    /// </summary>
    internal static class Program
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="args"></param>
        static void Main(string[] args)
        {
            Global.ServiceName = $"{Global.ServiceName}"; 
            bool startGui = false;


            if (args.Length > 0)
            {
                #region
                foreach (var arg in args)
                {
                    string _arg = arg.ToLowerInvariant();

                    if (String.Compare(_arg, "install", StringComparison.Ordinal) == 0 || String.Compare(_arg, "-install", StringComparison.Ordinal) == 0)
                    {
                        if (args.Length > 1)
                            InstallService(args[1]);
                        else
                            InstallService(string.Empty);
                        return;
                    }
                    else if (String.Compare(_arg, "remove", StringComparison.Ordinal) == 0 || String.Compare(_arg, "-remove", StringComparison.Ordinal) == 0)
                    {
                        RemoveService();
                        return;
                    }
                    else if (String.Compare(_arg, "help", StringComparison.Ordinal) == 0 || String.Compare(_arg, "-help", StringComparison.Ordinal) == 0 || String.Compare(_arg, "-h", StringComparison.Ordinal) == 0 || String.Compare(arg, "?", StringComparison.Ordinal) == 0)
                    {
                        ShowHelp();
                        return;
                    }
                    else if (String.Compare("gui", _arg, StringComparison.Ordinal) == 0 || String.Compare("-gui", _arg, StringComparison.Ordinal) == 0)
                    {
                        startGui = true;
                    }
                }
                #endregion
            }


            if (startGui == true)
            {
                Application.SetHighDpiMode(HighDpiMode.SystemAware);
                Application.EnableVisualStyles();
                Application.SetCompatibleTextRenderingDefault(false);

                System.Threading.Thread.CurrentThread.Name = $"{Global.ServiceName} (GUI)";
                Application.Run(new DebugForm());
            }
            else
            {
                ServiceBase.Run(new Actuator());
            }
        }



        static void ShowHelp()
        {
            ShowHeader("");
            Console.WriteLine(" Command line parameters:");
            Console.WriteLine("		-install	: installs the service on local machine.");
            Console.WriteLine("		-remove		: remove the service from local machine");
            Console.WriteLine("		-gui	    : service runs as gui application");
            Console.WriteLine("");
            Console.WriteLine(" In order to remove the service, it must be stopped.");
            Console.WriteLine("	\tUse 'net stop {0}' to stop the service.", Global.ServiceName);
            Console.WriteLine(" After installation you should start the service.");
            Console.WriteLine("	\tUse 'net start {0}' to start the service.", Global.ServiceName);
            Console.WriteLine("");
            Console.WriteLine(" Also be sure that appsettings.json file, contains the correct settings!");
            ShowFooter();
        }


        static void RemoveService()
        {
            ShowHeader("Service Remover Invoked");

            if (PatioServiceInstaller.IsServiceInstalled(Global.ServiceName) == true)
            {
                Console.WriteLine();

                if (PatioServiceInstaller.UninstallService(Global.ServiceName) == true)
                {
                    Console.WriteLine("\tService '{0}' Removed OK!", Global.ServiceName);
                }
                else
                {
                    Console.WriteLine("\tService '{0}' did not removed!", Global.ServiceName);
                }
            }
            else
            {
                Console.WriteLine("\tThe service '{0}' is not installed!", Global.ServiceName);
            }
            ShowFooter();
        }
        static void InstallService(string imageName)
        {
            ShowHeader("Service Installer Invoked");

            if (PatioServiceInstaller.IsServiceInstalled(Global.ServiceName) == false)
            {
                string fileImagePath = AppDomain.CurrentDomain.BaseDirectory + System.AppDomain.CurrentDomain.FriendlyName;

                if (!string.IsNullOrEmpty(imageName))
                {
                    fileImagePath = AppDomain.CurrentDomain.BaseDirectory + imageName;
                }

                Console.WriteLine();
                Console.WriteLine("\tService Name = '{0}'", Global.ServiceName);
                Console.WriteLine("\tService Path = '{0}'", fileImagePath);

                PatioServiceInstaller.InstallService(Global.ServiceName, Global.ServiceName, fileImagePath);
            }
            else
            {
                Console.WriteLine("\tThe service '{0}' is already installed!", Global.ServiceName);
            }

            ShowFooter();
        }

        static void ShowHeader(string message)
        {
            Console.WriteLine();
            Console.WriteLine($" {Global.ServiceName} Copyright© 2020-2026 Eurobank Equities S.A.");
            if (!string.IsNullOrWhiteSpace(message))
                Console.WriteLine(" {0}...", message);
        }
        static void ShowFooter()
        {
            Console.WriteLine("\n\n");
        }

    }
}
