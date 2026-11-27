#include <capd/capdlib.h>
#include <capd/mpcapdlib.h>
#include <iostream>

using namespace capd;
using namespace std;

int main() {
    cout.precision(30);
    MpFloat::setDefaultPrecision(200);

    MpVector gn = {
        -1.5275329970363014540358903E+00, 1.0481519478730373321674261E-01,
        2.6705670525193354032652095E-02,  -3.5274096609087091702341908E-03,
        8.1600966547531745172190486E-05,  2.5285084233963536176262552E-05,
        -2.5563171662784938463532541E-06, -9.6512715508912032163725768E-08,
        2.8193463974504091370756629E-08,  -2.7730511607990117243731657E-10};

    for (const auto& g : gn) {
        cout << g << endl;
    }
}
