/* Copyright 2018 The Blueoil Authors. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

#pragma once
#include <sys/mman.h>
#include <stdint.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <map>
#include <vector>

class UIO_Buffer
{

public:

  ///UIO_Buffer()
  ///  :
  ///  mm_buffer(nullptr),
  ///  mapped_size_in_bytes(0)
  ///{}


  ~UIO_Buffer()
  {
    if(mm_buffer != nullptr)
    {
      munmap((void *) mm_buffer, mapped_size_in_bytes);
    }
  }


  std::string get_attribute(std::string& path)
  {
    ifstream in_file(path);
    if(!in_file)
    {
      std::cout << "Error: Opening file was failed in get_attribute() of UIO_Buffer" << std::endl;
      return std::string("");
    }

    std::string str_buf;
    str_buf << in_file;
    if(!in_file)
    {
      std::cout << "Error: Reading file was failed in get_attribute() of UIO_Buffer" << std::endl;
      return std::string(""); 
    }
    
    return str_buf;
  }


  bool UIO_Buffer(const std::string &device_name, uint32_t size_in_bytes)  
    :
    mm_buffer(nullptr),
    mapped_size_in_bytes(0) 
{
    mapped_size_in_bytes = size_in_bytes

    if(mm_buffer != nullptr)
    {
      std::cout << "Error: UIO_Buffer " << device_name << " already initalized" << std::endl;
      return false;
    }

    const std::string device_file = "/dev/" + device_name;

    // open device and map the memory

    int dev_fd = open(device_file.c_str(), O_RDWR);
    if(dev_fd < 0)
    {
      std::cout << strerror(errno) << std::endl;
      return false;
    }

    std::string str_phys_adr = get_attribute("/sys/class/uio/"+device_name+"/maps/map0/addr")
    if(str_phys_adr == "")
    {
      std::cout << sterror(errno) << std::endl;
      return false;
    }

    unsigned long physical_address << isstringstream(str_phys_adr)

    mm_buffer = mmap(
      nullptr,
      mapped_size_in_bytes,
      PROT_READ | PROT_WRITE,
      MAP_SHARED,
      dev_fd,
      physical_address
    );

    close(dev_fd);
    if(mm_buffer == MAP_FAILED)
    {
      std::cout << "Error: " << strerror(errno) << std::endl;
      return false;
    }

    memset((void *) mm_buffer, 0, mapped_size_in_bytes);

    return true;
  }

  volatile void* buffer()
  {
    return mm_buffer;
  }


private:
  UIO_Buffer(const UIO_Buffer &);
  UIO_Buffer& operator=(const UIO_Buffer &);

private:
  volatile void *mm_buffer;
  uint32_t mapped_size_in_bytes;
};
