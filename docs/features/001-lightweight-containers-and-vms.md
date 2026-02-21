# Feature Spec: L2/L3 Hybrid Lab Virtualization

## 1. Goal
Establish a high-fidelity **"Break & Detect"** environment utilizing a dedicated multi-port physical NIC. This infrastructure must support the deployment of isolated workloads with granular traffic visibility.

## 2. System Context
The host is a NixOS server equipped with a dual-port external NIC.
* **Port A (Loopback):** Dedicated to Layer 1/2 monitoring and external traffic injection.
* **Port B (Switching):** Dedicated to Layer 2/3 guest traffic and bridging.

## 3. Functional Requirements
* **Virtual Switch Infrastructure:** Implement a declarative virtual switch (Bridge or OVS) that anchors virtual guests (LXC and QEMU) to the dedicated physical hardware ports.
* **Hypervisor Support:** Enable both LXC (containers) and QEMU/KVM (VMs) with support for nested virtualization.
* **Traffic Mirroring Capability:** Ensure the network architecture allows for transparent packet capture (e.g., SPAN/Mirroring) between virtual guests and the physical loopback port.
* **Host Isolation:** The Lab network must be logically and physically distinct from the primary management interface to prevent "Break" scenarios from impacting host availability.

## 4. Constraints & Technical Boundaries
* **IP Management:** The NixOS host must not provide DHCP services. All lab workloads (LXC/QEMU) must receive IP assignments via DHCP from the external VLAN gateway via Port B.
* **Declarative Only:** All networking and virtualization logic must be defined via NixOS modules (Flake-compatible).
* **Persistent Identifiers:** Use predictable network interface naming or MAC-based hardware identification to ensure ports do not swap after reboots.
* **Resource Access:** Guests must be able to utilize the full performance of the NVMe storage and Intel-based CPU virtualization extensions.
* **Kernel Geometry:** Security-relevant kernel parameters (e.g., IP forwarding, bridge-nf-call-iptables) must be explicitly managed to support detection tooling.

## 5. Expected Deliverables
1.  **Modular Nix Configuration:** A standalone Nix module containing virtualization and bridge logic.
2.  **Hardware Mapping:** A network configuration that binds specific physical NIC ports to the virtual fabric.
3.  **Kernel Optimization:** Tuning for high-throughput packet processing and nested virtualization support.
