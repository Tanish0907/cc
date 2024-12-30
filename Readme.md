```markdown
### CloudSim

#### My Scheduler

```java
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
      Calendar calendar = Calendar.getInstance(); // Calendar initialized with the current date and time
      boolean trace_flag = false; // trace events

      CloudSim.init(num_user, calendar, trace_flag);

      // Second step: Create Datacenters
      // Datacenters are the resource providers in CloudSim. We need at least one of them to run a simulation.

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
      int pesNumber = 1; // number of CPUs
      String vmm = "Xen"; // VMM name

      // Create VM
      Vm vm = new Vm(vmid, brokerId, mips, pesNumber, ram, bw, size, vmm, new CloudletSchedulerTimeShared());

      // Add the VM to the vmList
      vmlist.add(vm);

      // Submit vm list to the broker
      broker.submitGuestList(vmlist);

      // Fifth step: Create one Cloudlet
      cloudletList = new ArrayList<>();

      // Cloudlet properties
      int id = 0;
      long length = 400000;
      long fileSize = 300;
      long outputSize = 300;
      UtilizationModel utilizationModel = new UtilizationModelFull();

      Cloudlet cloudlet = new Cloudlet(id, length, pesNumber, fileSize, outputSize, utilizationModel, utilizationModel, utilizationModel);
      cloudlet.setUserId(brokerId);
      cloudlet.setGuestId(vmid);

      // Add the cloudlet to the list
      cloudletList.add(cloudlet);

      // Submit cloudlet list to the broker
      broker.submitCloudletList(cloudletList);

      // Sixth step: Start the simulation
      CloudSim.startSimulation();

      CloudSim.stopSimulation();

      // Final step: Print results when the simulation is over
      List<Cloudlet> newList = broker.getCloudletReceivedList();
      printCloudletList(newList);

      Log.println("MyCustomSimulation finished!");
    } catch (Exception e) {
      e.printStackTrace();
      Log.println("Unwanted errors happened.");
    }
  }

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
```

#### Commands

1. Clone the repository:

   ```bash
   git clone https://github.com/Cloudslab/cloudsim.git
   ```

2. Navigate to the CloudSim folder and install dependencies:

   ```bash
   sudo apt install maven && sudo apt install openjdk-21-jdk
   sudo update-java-alternatives --set java-1.21.0-openjdk-amd64
   mvn install && mvn test
   ```

3. Save the code in the following path:

   ```
   modules/cloudsim/src/main/java/org/cloudbus/cloudsim/MyCustomScheduler.java
   ```

4. Execute the custom scheduler:

   ```bash
   mvn exec:java -pl modules/cloudsim/ -Dexec.mainClass=org.cloudbus.cloudsim.MyCustomScheduler
   ```

---

### OpenStack

#### Install and Initialize MicroStack

```bash
sudo snap install microstack --beta
sudo microstack init --auto --control
sudo snap get microstack config.credentials.keystone-password
```

---

### Google Cloud (GCloud)

#### Setup Commands

```bash
gcloud init
gcloud projects create projname
gcloud app create
```

---

### VM File Transfer

#### Using SCP

```bash
scp path_to_file uname@ip:destination_path
```
```