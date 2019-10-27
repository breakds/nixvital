#include <arpa/inet.h>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctype.h>
#include <err.h>
#include <errno.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <netdb.h>
#include <string>

int PrintAllIPs() noexcept {
  bool first_catch = true;

  ifaddrs *addresses = nullptr;
  if (getifaddrs(&addresses) == -1) {
    return -1;
  }

  ifaddrs *address = addresses;

  for (ifaddrs *item = addresses; !!item; item = item->ifa_next) {
    if (!item->ifa_addr || item->ifa_addr->sa_family != AF_INET) {
      continue;
    }

    if (item->ifa_flags & IFF_LOOPBACK) {
      continue;
    }

    char ip[255];

    if (getnameinfo(item->ifa_addr, sizeof(sockaddr_in), ip, sizeof(ip),
                    nullptr, 0, NI_NUMERICHOST) == 0) {
      if (first_catch) {
        first_catch = false;
      } else {
        printf(" ");
      }
      printf("%s", ip);
    }
  }
  printf("\n");

  return 0;
}

int main(int argc, char **argv) {
  if (argc < 2) {
    printf("This program needs at least the real `hostname` as input arg.");
  }

  // If not for the `-I` case, just delegate to the real hostname,
  // which is passed in as argv[1].
  if (argc == 2 || strcmp(argv[2], "-I") != 0) {
    std::string command(argv[1]);
    for (int i = 2; i < argc; ++i) {
      command += " ";
      command += std::string(argv[i]);
    }
    return system(command.c_str());
  }

  return PrintAllIPs();
}
