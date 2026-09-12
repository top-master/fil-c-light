#include <set>
#include <map>
#include <vector>
#include <unordered_set>
#include <unordered_map>
#include <deque>
#include <list>
#include <string>
#include <sstream>
#include <iostream>
#include <algorithm>

using namespace std;

int main()
{
    deque<list<map<set<int>, vector<unordered_map<string, unordered_set<int>>>>>> omg;
    for (unsigned i = 5; i--;)
        omg.push_front({ });
    omg[2].push_back({ });
    vector<unordered_map<string, unordered_set<int>>>& wtf = omg[2].back()[{1, 2, 3}];
    for (unsigned i = 100; i--;) {
        wtf.push_back({ });
        for (unsigned j = 100; j--;) {
            ostringstream buf;
            buf << "bbq " << j;
            wtf.back()[buf.str()] = {static_cast<int>(i), static_cast<int>(j)};
        }
    }
    for (unsigned i = 0; /* LMFAO */ ; ++i) {
        auto& a = omg[i];
        for (auto& b : a) {
            for (auto& c : b) {
                for (const auto& d : c.first)
                    cout << " " << d;
                for (auto& e : c.second) {
                    vector<string> fk;
                    for (const auto& f : e)
                        fk.push_back(f.first);
                    sort(fk.begin(), fk.end());
                    for (const string& k : fk) {
                        const auto& fs = e[k];
                        cout << " " << k;
                        vector<int> gk;
                        for (int k : fs)
                            gk.push_back(k);
                        sort(gk.begin(), gk.end());
                        for (int g : gk)
                            cout << " " << g;
                    }
                }
            }
        }
        cout << endl;
    }
    return 0;
}
