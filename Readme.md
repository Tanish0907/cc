### cloudsim

# my scheduler
package org.cloudbus.cloudsim;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import org.cloudbus.cloudsim.core.CloudSim;

public class MyCustomScheduler {
  private static List<Cloudlet> cloudletList;
  private static List<Vm> vmlist;

  /**
   * Creates main() to run this example.
   *
   * @param args the args
   */
  public static void main(String[] args) {
    Log.println("Starting MyCustomSimulation...");

    try {
      // First step: Initialize the CloudSim package. It should be called before
      // creating any entities.
      int num_user = 1; // number of cloud users
      Calendar calendar = Calendar.getInstance(); // Calendar whose fields have been initialized with the current date
                                                  // and time.
      boolean trace_flag = false; // trace events

      CloudSim.init(num_user, calendar, trace_flag);

      // Second step: Create Datacenters
      // Datacenters are the resource providers in CloudSim. We need at
      // list one of them to run a CloudSim simulation

      // Third step: Create Broker
      DatacenterBroker broker = createBroker();
      int brokerId = broker.getId();

      // Fourth step: Create one virtual machine
      vmlist = new ArrayList<>();

      // VM description
      int vmid = 0;
      int mips = 1000;
      long size = 10000; // image size (MB)
      int ram = 512; // vm memory (MB)
      long bw = 1000;
      int pesNumber = 1; // number of cpus
      String vmm = "Xen"; // VMM name

      // create VM
      Vm vm = new Vm(vmid, brokerId, mips, pesNumber, ram, bw, size, vmm, new CloudletSchedulerTimeShared());

      // add the VM to the vmList
      vmlist.add(vm);

      // submit vm list to the broker
      broker.submitGuestList(vmlist);

      // Fifth step: Create one Cloudlet
      cloudletList = new ArrayList<>();

      // Cloudlet properties
      int id = 0;
      long length = 400000;
      long fileSize = 300;
      long outputSize = 300;
      UtilizationModel utilizationModel = new UtilizationModelFull();

      Cloudlet cloudlet = new Cloudlet(id, length, pesNumber, fileSize,
          outputSize, utilizationModel, utilizationModel,
          utilizationModel);
      cloudlet.setUserId(brokerId);
      cloudlet.setGuestId(vmid);

      // add the cloudlet to the list
      cloudletList.add(cloudlet);

      // submit cloudlet list to the broker
      broker.submitCloudletList(cloudletList);

      // Sixth step: Starts the simulation
      CloudSim.startSimulation();

      CloudSim.stopSimulation();

      // Final step: Print results when simulation is over
      List<Cloudlet> newList = broker.getCloudletReceivedList();
      printCloudletList(newList);

      Log.println("MyCustomSimulation finished!");
    } catch (Exception e) {
      e.printStackTrace();
      Log.println("Unwanted errors happen");
    }
  }

  // We strongly encourage users to develop their own broker policies, to
  // submit vms and cloudlets according
  // to the specific rules of the simulated scenario
  /**
   * Creates the broker.
   *
   * @return the datacenter broker
   */
  private static DatacenterBroker createBroker() {
    DatacenterBroker broker = null;
    try {
      broker = new DatacenterBroker("Broker");
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
    return broker;
  }

  /**
   * Prints the Cloudlet objects.
   *
   * @param list list of Cloudlets
   */
  private static void printCloudletList(List<Cloudlet> list) {
    Cloudlet cloudlet;

    String indent = "    ";
    Log.println();
    Log.println("========== OUTPUT ==========");
    Log.println("Cloudlet ID" + indent + "STATUS" + indent
        + "Data center ID" + indent + "VM ID" + indent + "Time" + indent
        + "Start Time" + indent + "Finish Time");

    DecimalFormat dft = new DecimalFormat("###.##");
    for (Cloudlet value : list) {
      cloudlet = value;
      Log.print(indent + cloudlet.getCloudletId() + indent + indent);

      if (cloudlet.getStatus() == Cloudlet.CloudletStatus.SUCCESS) {
        Log.print("SUCCESS");

        Log.println(indent + indent + cloudlet.getResourceId()
            + indent + indent + indent + cloudlet.getGuestId()
            + indent + indent
            + dft.format(cloudlet.getActualCPUTime()) + indent
            + indent + dft.format(cloudlet.getExecStartTime())
            + indent + indent
            + dft.format(cloudlet.getExecFinishTime()));
      }
    }
  }
} 


# commands 

git clone https://github.com/Cloudslab/cloudsim.git

> in cloudsim folder

sudo apt install maven && sudo apt install openjdk-21-jdk && sudo update-java-alternatives --set java-1.21.0-openjdk-amd64 && mvn install && mvn test

>is code ko modules/cloudsim/src/main/java/org/cloudbus/cloudsim waale folder me MyCustomScheduler.java file me save karna hai

mvn exec:java -pl modules/cloudsim/ -Dexec.mainClass=org.cloudbus.cloudsim.MyCustomScheduler

### openstack 

# command

sudo snap install microstack --beta && sudo microstack init --auto --control && sudo snap get microstack config.credentials.keystone-password

### gcloud 

# command

gcloud init

gcloud projects create projname

gcloud app create 

### vm file teansfere

# command

scp path to file uname@ip:destination path
