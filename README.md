# **LMK-Control**

**Fix HyperOS aggressive app killing and unstable multitasking**

---

## **Overview**

HyperOS is extremely aggressive with background app management. Even locked apps are frequently killed, leading to:

* Constant app reloads
* Broken multitasking
* Unpredictable memory reclaim despite free RAM

This module targets the root causes of the problem by:

* Stabilizing Low Memory Killer (LMK) behavior
* Optionally resizing ZRAM
* Optionally disabling excessive system logging
* Optionally applying UI smoothness tweaks

All options are configurable at install time using volume keys.

**Root is required.**

---

## **What This Module Does**

### **Core Features**

* **LMK stabilization**
  Applies more reasonable LMK thresholds based on total RAM.
  Reduces random background kills and mass app reloads.

* **PowerKeeper mitigation**
  Designed to be used alongside **[App Retention Hook (LSPosed)](https://github.com/Xposed-Modules-Repo/com.hchen.appretention)**.

* **Automatic RAM detection**
  Detects device RAM (4GB / 6GB / 8GB+) and applies matching configuration.

* **Persistent tuning**
  Uses `service.d` so changes survive reboot.

---

### **Optional Features (Selectable at Install)**

* **ZRAM resizing**
  HyperOS often sets ZRAM equal to physical RAM.
  This module resizes ZRAM to approximately **75% of physical RAM** (RAM ÷ 1.333).

* **Disable excessive logging**
  Reduces log spam that wastes CPU time and memory.

* **UI smoothness tweaks**
  Applies safe SurfaceFlinger, ART, scheduler, and preload properties.

---

## **Requirements**

* Root (Magisk or KernelSU)
* KernelSU users supported
* Android with ZRAM enabled
* HyperOS-based ROMs (primary target)

---

## **Installation**

1. Download the module zip
2. Flash via Magisk or KernelSU
3. During installation, use volume keys to select options:

   * Disable logging
   * Enable ZRAM resizing
   * Enable UI smoothness tweaks
4. Reboot

---

## **Important Post-Install Step ⚠️**

To actually keep apps alive, you must lock them manually:

1. Open the **Security** app
2. Go to **Boost speed**
3. Tap the settings icon (top-right)
4. Select **Lock apps**
5. Choose the apps you want to keep alive

Locked apps are given higher priority and are far less likely to be killed unless the system is under real memory pressure.

---

## **How It Works **

### **LMK Tuning**

* Adjusts LMK timeouts and thrashing thresholds
* Prevents panic killing during brief memory pressure
* Improves cache stability and multitasking consistency

---

### **ZRAM Resizing**

* Reads total physical RAM from `/proc/meminfo`
* Calculates ZRAM size as:

```
ZRAM = Total RAM × 3 / 4
```

* Safely disables, resets, resizes, and re-enables ZRAM at boot

---

### **Logging Control**

* Disables excessive Android, Audio, SurfaceFlinger, and vendor log tags
* Reduces background CPU usage and memory churn

---

### **UI Tweaks**

* SurfaceFlinger optimizations
* ART and dex optimization tuning
* Scheduler and preload improvements

Designed to improve smoothness, not inflate benchmarks.

---

## **Notes & Limitations**

* This does not increase physical RAM
* App reloads can still occur under extreme pressure
* Results depend on ROM, workload, and OEM policies
* Designed for stability, not aggressive over-tuning

---

## **Recommended Companion**

For best results, use alongside:

* LSPosed
* App Retention Hook (PowerKeeper mitigation)

---

## **Disclaimer**

Use at your own risk.

While the module avoids unsafe kernel changes, memory tuning always depends on device behavior and ROM implementation.
