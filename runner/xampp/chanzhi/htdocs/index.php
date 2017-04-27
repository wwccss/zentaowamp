<?php
error_reporting(0);

if(isset($_GET['mode']) and $_GET['mode'] == 'getlogo')
{
    header('Content-type: image/png');  
    die(base64_decode('iVBORw0KGgoAAAANSUhEUgAAAKsAAAA8CAYAAAAZi0riAAAACXBIWXMAAAsTAAALEwEAmpwYAAAKTWlDQ1BQaG90b3Nob3AgSUNDIHByb2ZpbGUAAHjanVN3WJP3Fj7f92UPVkLY8LGXbIEAIiOsCMgQWaIQkgBhhBASQMWFiApWFBURnEhVxILVCkidiOKgKLhnQYqIWotVXDjuH9yntX167+3t+9f7vOec5/zOec8PgBESJpHmomoAOVKFPDrYH49PSMTJvYACFUjgBCAQ5svCZwXFAADwA3l4fnSwP/wBr28AAgBw1S4kEsfh/4O6UCZXACCRAOAiEucLAZBSAMguVMgUAMgYALBTs2QKAJQAAGx5fEIiAKoNAOz0ST4FANipk9wXANiiHKkIAI0BAJkoRyQCQLsAYFWBUiwCwMIAoKxAIi4EwK4BgFm2MkcCgL0FAHaOWJAPQGAAgJlCLMwAIDgCAEMeE80DIEwDoDDSv+CpX3CFuEgBAMDLlc2XS9IzFLiV0Bp38vDg4iHiwmyxQmEXKRBmCeQinJebIxNI5wNMzgwAABr50cH+OD+Q5+bk4eZm52zv9MWi/mvwbyI+IfHf/ryMAgQAEE7P79pf5eXWA3DHAbB1v2upWwDaVgBo3/ldM9sJoFoK0Hr5i3k4/EAenqFQyDwdHAoLC+0lYqG9MOOLPv8z4W/gi372/EAe/tt68ABxmkCZrcCjg/1xYW52rlKO58sEQjFu9+cj/seFf/2OKdHiNLFcLBWK8ViJuFAiTcd5uVKRRCHJleIS6X8y8R+W/QmTdw0ArIZPwE62B7XLbMB+7gECiw5Y0nYAQH7zLYwaC5EAEGc0Mnn3AACTv/mPQCsBAM2XpOMAALzoGFyolBdMxggAAESggSqwQQcMwRSswA6cwR28wBcCYQZEQAwkwDwQQgbkgBwKoRiWQRlUwDrYBLWwAxqgEZrhELTBMTgN5+ASXIHrcBcGYBiewhi8hgkEQcgIE2EhOogRYo7YIs4IF5mOBCJhSDSSgKQg6YgUUSLFyHKkAqlCapFdSCPyLXIUOY1cQPqQ28ggMor8irxHMZSBslED1AJ1QLmoHxqKxqBz0XQ0D12AlqJr0Rq0Hj2AtqKn0UvodXQAfYqOY4DRMQ5mjNlhXIyHRWCJWBomxxZj5Vg1Vo81Yx1YN3YVG8CeYe8IJAKLgBPsCF6EEMJsgpCQR1hMWEOoJewjtBK6CFcJg4Qxwicik6hPtCV6EvnEeGI6sZBYRqwm7iEeIZ4lXicOE1+TSCQOyZLkTgohJZAySQtJa0jbSC2kU6Q+0hBpnEwm65Btyd7kCLKArCCXkbeQD5BPkvvJw+S3FDrFiOJMCaIkUqSUEko1ZT/lBKWfMkKZoKpRzame1AiqiDqfWkltoHZQL1OHqRM0dZolzZsWQ8ukLaPV0JppZ2n3aC/pdLoJ3YMeRZfQl9Jr6Afp5+mD9HcMDYYNg8dIYigZaxl7GacYtxkvmUymBdOXmchUMNcyG5lnmA+Yb1VYKvYqfBWRyhKVOpVWlX6V56pUVXNVP9V5qgtUq1UPq15WfaZGVbNQ46kJ1Bar1akdVbupNq7OUndSj1DPUV+jvl/9gvpjDbKGhUaghkijVGO3xhmNIRbGMmXxWELWclYD6yxrmE1iW7L57Ex2Bfsbdi97TFNDc6pmrGaRZp3mcc0BDsax4PA52ZxKziHODc57LQMtPy2x1mqtZq1+rTfaetq+2mLtcu0W7eva73VwnUCdLJ31Om0693UJuja6UbqFutt1z+o+02PreekJ9cr1Dund0Uf1bfSj9Rfq79bv0R83MDQINpAZbDE4Y/DMkGPoa5hpuNHwhOGoEctoupHEaKPRSaMnuCbuh2fjNXgXPmasbxxirDTeZdxrPGFiaTLbpMSkxeS+Kc2Ua5pmutG003TMzMgs3KzYrMnsjjnVnGueYb7ZvNv8jYWlRZzFSos2i8eW2pZ8ywWWTZb3rJhWPlZ5VvVW16xJ1lzrLOtt1ldsUBtXmwybOpvLtqitm63Edptt3xTiFI8p0in1U27aMez87ArsmuwG7Tn2YfYl9m32zx3MHBId1jt0O3xydHXMdmxwvOuk4TTDqcSpw+lXZxtnoXOd8zUXpkuQyxKXdpcXU22niqdun3rLleUa7rrStdP1o5u7m9yt2W3U3cw9xX2r+00umxvJXcM970H08PdY4nHM452nm6fC85DnL152Xlle+70eT7OcJp7WMG3I28Rb4L3Le2A6Pj1l+s7pAz7GPgKfep+Hvqa+It89viN+1n6Zfgf8nvs7+sv9j/i/4XnyFvFOBWABwQHlAb2BGoGzA2sDHwSZBKUHNQWNBbsGLww+FUIMCQ1ZH3KTb8AX8hv5YzPcZyya0RXKCJ0VWhv6MMwmTB7WEY6GzwjfEH5vpvlM6cy2CIjgR2yIuB9pGZkX+X0UKSoyqi7qUbRTdHF09yzWrORZ+2e9jvGPqYy5O9tqtnJ2Z6xqbFJsY+ybuIC4qriBeIf4RfGXEnQTJAntieTE2MQ9ieNzAudsmjOc5JpUlnRjruXcorkX5unOy553PFk1WZB8OIWYEpeyP+WDIEJQLxhP5aduTR0T8oSbhU9FvqKNolGxt7hKPJLmnVaV9jjdO31D+miGT0Z1xjMJT1IreZEZkrkj801WRNberM/ZcdktOZSclJyjUg1plrQr1zC3KLdPZisrkw3keeZtyhuTh8r35CP5c/PbFWyFTNGjtFKuUA4WTC+oK3hbGFt4uEi9SFrUM99m/ur5IwuCFny9kLBQuLCz2Lh4WfHgIr9FuxYji1MXdy4xXVK6ZHhp8NJ9y2jLspb9UOJYUlXyannc8o5Sg9KlpUMrglc0lamUycturvRauWMVYZVkVe9ql9VbVn8qF5VfrHCsqK74sEa45uJXTl/VfPV5bdra3kq3yu3rSOuk626s91m/r0q9akHV0IbwDa0b8Y3lG19tSt50oXpq9Y7NtM3KzQM1YTXtW8y2rNvyoTaj9nqdf13LVv2tq7e+2Sba1r/dd3vzDoMdFTve75TsvLUreFdrvUV99W7S7oLdjxpiG7q/5n7duEd3T8Wej3ulewf2Re/ranRvbNyvv7+yCW1SNo0eSDpw5ZuAb9qb7Zp3tXBaKg7CQeXBJ9+mfHvjUOihzsPcw83fmX+39QjrSHkr0jq/dawto22gPaG97+iMo50dXh1Hvrf/fu8x42N1xzWPV56gnSg98fnkgpPjp2Snnp1OPz3Umdx590z8mWtdUV29Z0PPnj8XdO5Mt1/3yfPe549d8Lxw9CL3Ytslt0utPa49R35w/eFIr1tv62X3y+1XPK509E3rO9Hv03/6asDVc9f41y5dn3m978bsG7duJt0cuCW69fh29u0XdwruTNxdeo94r/y+2v3qB/oP6n+0/rFlwG3g+GDAYM/DWQ/vDgmHnv6U/9OH4dJHzEfVI0YjjY+dHx8bDRq98mTOk+GnsqcTz8p+Vv9563Or59/94vtLz1j82PAL+YvPv655qfNy76uprzrHI8cfvM55PfGm/K3O233vuO+638e9H5ko/ED+UPPR+mPHp9BP9z7nfP78L/eE8/sl0p8zAAAAIGNIUk0AAHolAACAgwAA+f8AAIDpAAB1MAAA6mAAADqYAAAXb5JfxUYAABgTSURBVHja7J15mBxXee5/36lTPd3TM5qRNFpGq2XJi2zLIvb1hmVsjOJgTC4EbBMW5QGc4FzAkMTwQDZywxaSQG6IWRIuXAcbkwg7JgQC2JiQYCsyJl6wbHmTrMXSaLSMRjPTay3n3D/q9ExNa0aapbXF/eqpZ6qq1Uudes+3vOc7p8RaSxNNnApQzSZooknWJppokrWJJlmbaKJJ1iaaaAykER/y0o4vtIVhcU0YFV8VBIVzDlX6zz5QGVhQCov5clhQGcHkdK7Y6bf1tPutz/p+brPW+Z/6fv6hc879s8J0v7+paDTJekT0Hbg3F8fVN4Zh+Te2VyrXHLQZZVQ7Ob+TrM4hMmK6BVDuOIpKVIM+CA6SM4OmyzM/yvi5r2vd+s+Llry33CRrEw0j6+Dg/TNMHLx3b7nw4U3Fyix0JyIeWhSt2qPTz9KiNApBlAULYJMvcqQKbUgpDAmjEGxEHPayQJuDHZn8X2rd+qWuuTcONsnaxJTJWio9KNZG6/aUBj73YN/+LiNtZDzFqpnddPpZBKEaQzmOqUQxkY3BxlhrMFgsZtjKtigh73vktIe1hkJYZn9pEBMdZHku3zezddbvaZ27s719rW00WVfMn3OklzXwLeB0oAX4KXDzBD72WuDLwC5c9zwKFgL3Af/LHc8Evg10ABMJi3JAALwJ6K177VeBLwC7gfnAe4AHThVCbundf8Sbc1SUyxvmRya68+6XNq09EGgWts7ksrmL8SVLMdL0V0OsrQIxEKGVQUxMaA3GGspxQljBooAqQiEUfFEo8WjzfVZ0ziGynbx4aNdsys9//aK5q9aVyw+ty+XW9B7HttLAFUBXrY9O8H3zgaVumyhWp/YzwBrAm+TvzY1xrhtY4jaAuf9dLOtRyVqpbLhid+nQvX/93INdK9qXcf3SlbR4bQRxRCUeJDIBoa2wv1JkMCxTjiJiY9BKyGmPvNdCZ6aFFk/jIXhKiGNBAUosIhasob+qEJNhRecyhIAf7X5o7eXdF2+qVDa8KZu9/MHj1B7G9bipvG9aOeIELfJY7zvaOfOyIGux8JPrn+h/6a6PPfn9zMdWv5kzZ+QpRiHbCtvZuH8b+8rlJB4VQbAIMuzqBfAkSawUI5sn0O7r4WNfKdp8nzm5GcxsaSO2ObJehlcveSW7hrZ3FcLiA+XyQ2/P5dbcc4q0aQTcAQwA2RSBBoEbXYhxNDwE/DswO3Wu4KzlW16uMeu4ZB0c+MENGw68uP6jT31H1l/xbnw87tn+DE/09wwHuiIjxCSV8Xup8x7Q4nl0tWSZ29rKzGyOjOcNd3ctCgFiG9MfH6JgBhBryKgM3fklBPGLmR2D0beKxf94Sz5/5d2nQJtWgQ8DB8d47YwJknW9izvrce4EyFqvnX8G+GCq40wFnS4evwYou8/7FPBCA9vtDOCvgI9Niqz9fd9e+2j/rm/e9Mhd8q0r38oPd29j476dI1m9CMp5G3EaVc2yilgySnFB1zyWtXeglYdBGIgjBuKIZ4IqFWMxgMGQU4pu32eOr8iJYKzFV+CpkH3lnRTCIXb0PybWXP3NoaEHDrW3r/3RMSTasZYVpMH/byKYbCw9HmalYuqlQB54RYPbZ8mkLOuBfeuX7Cwduudd//WPuhiHfObJR0G8Yd1UUiSVGnmd+794bjcXzJqH1preqmVLNSAwIaGNiKwhtDFWLIuyGeZ5GmMjgrDKnv69bC0XCKIYLaCwaMSFETFbDz3Po7079QdWv+fuQ/3/en7nzOt2HkMXHp0EncGexB0OwD/hYcDePXd4FRPd88FN3+8YCCsIUDYhEA67/XS3F+dzrlu0nNVd3QxEmh1BTLUSEtqQqo0ITERkQzozmmUtHtUwYNO+HWwYHMAThjfluq0HaHdOu5AispZCVOGu5+7peM/Kt99zYP/dl3XNuSGe4jW/GVjrsvGDwxJGsrWklACcy/5H107ibpLnMuyvAX87xudnXcxacFl+jUAl4LIJ/sbfAi50UtawKAPMm8B7HwP+Dugbh7gFpxjckrqVm4H/59z9WFa91bVV4I6/59pk7zTDpQzwu3XXOWHLestXdzxx0bOFA3jiEduYclxNEVRSfsqyetY83rrsHAqmnR2VmEocENiAqkmIWrUBnRpOa9E827+P27fuQawdTrQE8GuEdZ+uUyTVkljYyApg2VHo4Sc9Gy66ev5FtwB/PcVGWuV00Ym4xs4jxIhPjkNWD7humkbkfLdNBf/ltiOhG3hfyq0/CXxuEt9xn9sagXdOmqw9u77Svb08+Klv7n4arfSw6FGOw1ERuwCeEm4951IWtHXTW81SMSFVUyGwAYGJCGyEIWB1Xnh+YB+ff34n1lq0jBDSc4QMUoTVAqFNftQIYSGytW+2/KTnYc7rOP1TPbu/tn7Bwpv2nEBXb+sIOt1YVqb4vqnAq0vEGhkjH7NrSFvWj9yxa3OrLx6+2OFLiW1MYOPhT8x7mr+48BqMWkxfYAhshcAEhCamamICG5JTEUsyMX/79C/oD6qIjMhaWiwBgp8ibpgirELwsMnx8OsWrLufJub+nv9svXHxlR8BfqcBjfUE8COXMGSBtzIith9wmbkHVIAbSEaf6vEs8F1g3wRjxjnAw6njkgsr8s7dHw0tLjYb5GUEDbBzx22zeyrFmzcNHCCvfEAomaTvVU2IIMQ2ptPP8DeXvI6yOY1iFBGaKsZExDYkdIlUmxfSyRCfeOIXRMYkSZhIMgCAEDjCho6woSNkzcJqR9hQbBLF2zgJA2SEsE/2b+WqOatv3rb1s59YtvxDfdNsg+8Bf5zq5dcAi9zxTuD9qf971jhk/U/gf07jNwwxsWHdlzVqlvXtD/b1ZvOi8dSIVS4ZqJiQFuXjK8Vtl7yOkLOo2CpVGxLaxJIGJiIgJCcBs1SRjz/+yGhZyzrCOnkrqiNs5Fx+nHL9CiESS2gqzlaNJuzGvs3Z185e+Q7g8w10Q/5RMl2vSZlRuAr4FeeBJuJN7gUemRZZQ2Pe9exgP3nl49nRIUTJhETW8KWLX4/nraIURYQmxpiYqg0JbExoI2Ibc1q2xK0/30jsCkuE0QMH4ka0hCQO9QRi68iZ+mtcSFA1hthE+MJhhH28fxuvmXXmOxtA1kbgeuBu4KXjJB3lXTZ9iRPrTxRuZKQYZ6IeZOpk3bb1LxdtL5dfYa0ir3TClLoxkHeecQHzWs9lMPaJbICxMbGNiE2MMSGhiTk9V+GTT/2cchyO0mGVHcPCik0spwVPLJEVtCNujcAKi7EhyiVW1BG2EAVsK+1/xdNPfXTRCb5hAG3u7+Lj/L3+Cb7u6hSS22mFAVfvrlTJKH/EK5qRXDGvNa9feD5VOwtjShgbExETEhETEdoI3wvpKe5nx9AQuLcmxExce21fAGUtRnBJV82y2mGiapvIYtbGLoa1w9JVPWG3FPezqL37aqdrnkjYl9n3jvf921wiql0C2N7IDqyBy/YFERnPdxaRYdkKBR84/1X46mzKJsKQ1KnG1mJiQ2RiQmM4LVfm1scfJzYxIgoDCAaxIKJG7RtArEFEocRgUBgLWgzGKiJMMoLlZCyoETYVYTrCbi31cVV792UnAVnTqJAMPOx0Ou1YeAH401RStdMpDTFjl/1BUre6Bri9QSSzqXi9UaR/NbAjdXxJneoxbbKeXYgZtqxiRmLWrHicOWMJVVpQNgRrk0Jna4jEEFuDIWYwGGIwcu7fGpTUKgUsYg3IyH4SHghiDQZJCGshthaReFhfxTKKsEpSTer2e6oFgLNPsqQjdjfo4FH+3/bUfmGCsVzLy1oNKBu7UtD46vDOtXbJmfhqGaGJEGuxJLFk8g+MWGb7Id/ZuX24Wt+SVO6PKnCxqTLC4f2E2EYYlrWUhUhSfT5FWJ/Ua46wxThiMA5WNpNyAD4O/CFHr4SKnJ6czkyuAzZNIAbWJLMaXgf87LiTNbQyo6UWAtS9eO7s04jJOc+WEC0h1gixZ/oRD+/d42YCjPiUGintUQlrnYVN/jIGYWtWdSzCluJwxklGGg+43CV94w0jbmF0qWA78EoXfI1XyrcXuPQI37vQEfCsKfzmduC8KSSUx5essZWc70IAJSN09URoz8watoBgUS72VFg85+hDE2Hx0GKIUiNdyTzBGmEdw6x1QXF6X8ARVlIuPk1YnTquJ2zVmtxJRtYs8C+TfM9iYEMD9eJjjRMyPKtFBK0Ot/5zWtvIel2UTeL0awUoypHac+SqxDFaecNJ2XQIiwjGTo6wDcgM0h8RUCsxGz8ePVmxnkScP5pAP0QyQvf7KdL9AriNpGb1SERUJBVYz58QsvoiZV/5ufoOs7xzYaI9p2aOJvpobS0AQaMwsSGrNBU4IYTNiCpPsw3WAO8GZjj3ls7g55NUxWuS8fsVJzFZJ1MJ1Q18hJERuWdIahNO7gTLFzuYUZmc1Nyww9zWDmIyWKqYJJ1KEiyxSYEJFk8syghZ0aBIEVaIbHRcCNuq/OkWc1zltrGwgMmXIpaB17hsf+Y4/+dZkpK830npk7/sYtbxwpoeJw3dewzcuHAKQGfEPJPVep7UObhWnRumWk0JECuIFTwLnig0Qtbzk+IXp8tWXEKVWNjDCZsI+ocT1lrrYuZ6wibDq2MRNieaTp15ZgpynT4GNzzlW3jOSVdHKmHcW0fwrRP4zka532WMrnM4JWoeNPBsh6euOmgzo++E6MQaDocACVuSMX5BY9GiyHmZZJi2dpsUVGrvGoOwyejUWIQFMyZhZVzCzsu216zUZPAi8Lhz+b118agGzkyRueIIourIucJZw1MVX6w7PniqkHVjh7a/XTCjyRpbC5JYvIRgbrzfbaDQQKuXHSHrKMIyKcLWQoTJEPbs1lkAGyd5zXdw5BGvlxgpEdxMMr1kstLVZUeRrl5w1i0tHV06Aenq4gbc888yeoGNAnCrUyR815kbBdVosv64U4fsi0ZLZ+UghlzoQklx1VIJiRSCQiFoYjIszrfzUnFo5Be6yq1jTdhVbXMA/q2B7dGWZJXTlq6+NwXpauNxME7XOGKm8UZH2CHg+0x/Ss4xi43VsuUf3t2mKk+0eBpfZcgoH60y7CsPIBK4RX/cEKlTAbAKEYWH0Ff1eO3SM8gpn7zSw1ur8skqD0/5+MpDix5DL0osdm2YYWQULCGsdfvW7RsrGCzGQouX4fy2OU+ce95nGllx9eEjJEWnOjqBO+vOfQ74MfAdd/w6kjlRjcIvnDe4kGSg5PbpWlYU9vYuP/z83lTcOlCJgAoWjXJlD4JCiaCUwrNJOBBbYUZLO/OzOXorrvPUlRkOW1grxCYcRdijWVhBEitbZ2Gvnr2MFuXd3sCGvZbDF1j4wolwdw1I8sbC7Yxe9+pJ4EPA1Yye5fA1kpkPjUjmisDPGxkGANw1Vxc+0xfNz6VjT2NiPBEiEURJMnolLgwQhScaIWJnOeTXzlzFHU895upPGVVmWCOsNREoJkVYsBg7mrDWCm+ev7IC3NWgdpg9Rhz79+4GLwBeD3zlCO//Kcn0lyEmNk5Rmy5zvTveA/yea7WWCd43A+yf4PX9sXP36Tj1V93+v5GM81+S6nh3po5PqgSLJUtv6evZ9ZWvzM7EH+wLRqzrULVMrmXGSAAgI9GqQiEieCIExmNvaLhuxdl8f8tzhyVbSQtIsiSfOzcRwqZlrhphc8rj0llLOb115t8tWHhTX4Pa4Z8YvV7Ao8C73P6fkCwbuRP44Tjv3zpGhn00XJYiaz/J+gTHAleQFLmkcbO7nhrW1VnSi4FPA39wMpE17b7+vNsfKma8JGbVyueFgwfISDmVVCWERTwUSczqiYcSxaFQCL0cr19xNnmnveaVJifJ36zStCqNVhotSSx7tBh29LHljUvPYvWs2bx/2SuLwJ83qA0+CVxZ91Pe5vZ/2xEV4JskI1ppF5w5iYyOjHO+PlT6uruWenXivXXnfp/xB0tOnGUFWLDoPXv27rnjj7pbqv+np5p4osiGVOMqnvhEbqBVUHio4TDAkyghnyj2V2My2uct56zivi3PsbtcTFnY1ETEURY2SlH1cAsrWOZlW/nypddSDMts3DPA8vzsP+qac8OeBlz/a0nK6tK4KWVlfi11fibwDZLVXGo/9+0kC5Q9NklhfahOPloK/Kv7zMl8jgEuchbwq2O8/n+B5anj5931jYUvk1RepUn7z8A5JKNnE8E/kEwPn0gnjt21zps0WR1um+sX3lYwuYsG8REDmw/s5xXzfAKjUZKQVFQyu19sshiwUh4ajWcNQ3HMw4WAS5afRRwU+fft2+ipFKkvl60RVpQlMvGYhD23Ywa3nnclp+cXUzGH+PjTP+Pr/+NtP8cEtzWAqHPHiHm/WmeJbgGeTrXTa5zF+TN3fA/wiQbIPXmXiU8Fu0hW667HO8fI7Ndx5GKc97msvdaROlwbvXoSoc2xt6wA87p/Iz6wb/31p2WHnnzOdHYkJYAB+0sFOlpmENlatOolm2iEGE2MRuGLh4cGsTw2VAER1qw4kyyGnuIAj/b2sKUwOIqw4jTZyMTkPMWFs+dz7cJlnN4+l1Y9F0+WUDGbuXnjd7njkncPZJW+vnP2GxpR/fQNkiqjGjaQrDFFnSV6i4tpa/g08CDJGqpDzjpvOkGe8SVnDevrI85wVjWN32VisxHWOaWghquA/+22ehzX8swxpY/+vm+vrUjbD54fyuowDglNwFldszD4FKOQwIQEJqBiKlRNQCWuUjEBZRNSsgElE1A0EVUTElqDtRF5DxZmNR0qWeUlthGRjQAhoxQZETLSQkSewHSS9drozORoly3ctPFf+NIF66Jf6uy+tr197WHr40/ymQJLgHc4953GGkfYbmd9xIkYA85Fpy3fFpJh2doXvwl4AxNfqGyfk4uucMcHSRZTs0xsxqpyuumXXAhSj4frsvlvMblFiG8B/qbu3JVO9Ujjl51Ssq9Bnu6BLb37vztpnW5w4Ac3lEzr+ucGldQIu7JrFoFVDIVhsgCbI2nVBpTjKhUTUTIJWSs2omoiQhsjNsZgsCbGSG3JzGS2qodGK4+8JAMSeZWjTbcy2/fx2cb7fnYfX7xwnb1s9mnjLiY8SbL+FvCbjB66LDjrNJ/R04U9dz7k8LX5V9dZoMnio6lwYjPJQsGNwOeBD6SOd5PMU5vs88Z+SLKARQ3PASs5xjNqj/QAjHHF7Bkd197d7psbz5ulgqz28VWGZw4cJIqqzMwkYYCIlyRZaDzl4ymNJxpf+WjRZJRHVmkynlMDPJ9W8cgpn5xoWsnQqjSt4qPEo0V8fOXT5RfoK23ilkd+zN9f+pvB5XOW33iMV71uc3qqcslBbfNcYjV3moL80dq+UVVPb6gjKk7ZmMqD8d7B6AKXs0iWxTzxasCYUX/bq++pVDbsXTVb3fvCIb/rUBV2DBRozygWd7RxMPTpDwyeeHjWQ4lFK4M2Bl+SRwnFxK4ruinZCFYEJcmK2J4otNJ4ZOjwFd2ZPta/uIldhSrffdX7DyxqnXk8H4BxKmM+hw9sfGwM1z1RHAB+Hbi/Lml7xCkHxx0Tsg7l8ob5xpo79xTN2pcKMZU4JDIh89uydOYyDMQBeyoViiZZm7VikqUvQxthSZ6FhY2Sh2GYJDeyYhE8tPKY1yJ06ICn+nv52pbNvHvphdx0+isfaPFbJ/RooUmGAfOcXNJFaiR4khZR3MBBaRpt/4dO460lcmdN47M8l+SlZ/reX+fGG/E7a/h1kmk0xzUMmFARci53eW+p9OA13a1mXacff3ZXUeb0ln16CxV2DQ7SltEsbs+CaMo24mCk6QurDIUQW0EwWEn+5nyPDq1o9ywZZSgFFX66ZweP7Ovl0lnd3H3Bm/Z3t3V9yBN1Zy635ljER3uZ3orNjcJGkmHNkkvYpoNVJHW933OdKcvkFgc+Ej7t4tRFLixYyUgJ5clnWUclXoP3t5s4eF85jG7trdC1ryqU4pjIJCqBtRHZjEdHTuN7ifZrsIhN1nAtVEv0lobY1t/HoaCMryzntM/giq6FB+blZn5O69Yvds29cWgyv6n5OMyXB6b9oOE4Kr9jIIh/pT/EOxR7DMZCObYEJkwe6GYiIpM8CCOIA8RUyUuFORoWZlviJa3t9/l+7hvNBw03cczImkb9I9zLYfnsUhgsqITlfCUqK7GhyXh+Mat0T077zUe4NzE1sjZvdBOnClSzCZpokrWJJppkbaJJ1iaaaJK1iSYag/8/AMTKY9RoqEHQAAAAAElFTkSuQmCC'));
}

$config->langs['cn'] = '简体';
$config->langs['en'] = 'English';

$lang->cn->visit = '访问';

$lang->cn->links['chanzhi']['link']       = '/chanzhi/';
$lang->cn->links['chanzhi']['text']       = '蝉知';
$lang->cn->links['chanzhi']['target']     = '_self';

$lang->cn->title    = '欢迎使用蝉知集成运行环境！';
$lang->cn->xampp    = " <a href='http://www.apachefriends.org/en/xampp.html' target='_blank'>xampp</a>";
$lang->cn->official = " <a href='http://www.chanzhi.org' target='_blank'>蝉知官网</a>";
$lang->cn->adminer  = "<a href='/adminer/' target='_blank'>数据库管理</a>";

$lang->en->visit = 'Visit ';

$lang->en->links['chanzhi']['link']       = '/chanzhi/';
$lang->en->links['chanzhi']['text']       = 'chanzhi';
$lang->en->links['chanzhi']['target']     = '_self';

$lang->en->title    = 'Welcome to use chanzhi!';
$lang->en->xampp    = " <a href='http://www.apachefriends.org/en/xampp.html' target='_blank'>xampp</a> ";
$lang->en->official = " <a href='http://www.chanzhi.org/en' target='_blank'>Community</a>";
$lang->en->adminer  = "<a href='/adminer/' target='_blank'>MySQL</a>";

$acceptLang = stripos($_SERVER['HTTP_ACCEPT_LANGUAGE'], 'zh-CN') !== false ? 'cn' : 'en';
$acceptLang = isset($_GET['lang']) ? $_GET['lang'] : $acceptLang;
$clientLang = $lang->$acceptLang;

?>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
  <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
  <title><?php echo $clientLang->title;?></title>
  <style>
  </style>
</head>
<link rel='stylesheet' href='../chanzhi/zui/css/min.css?v=2.5.3' type='text/css' media='screen' />
<link rel='stylesheet' href='../chanzhi/template/default/theme/default/style.css' type='text/css' media='screen' />
<script src='../chanzhi/js/jquery/min.js?v=1.3.beta' type='text/javascript'></script>
<script src='../chanzhi/js/zui/min.js?v=1.3.beta' type='text/javascript'></script>
<style>body{background-color: #f1f1f1}
.container{padding: 0}
.modal-dialog{width: 800px}
.modal-footer{text-align: center;margin-top: 0;}

.table,.alert{margin: 0;}
.table+.alert{margin-top: 20px;}
.table.table-form>thead>tr>th, .table.table-form>tbody>tr>th, .table.table-form>tfoot>tr>th{color: #666}
.table.table-form>thead>tr>th, .table.table-form>tbody>tr>th, .table.table-form>tfoot>tr>th, .table.table-form>thead>tr>td, .table.table-form>tbody>tr>td, .table.table-form>tfoot>tr>td{vertical-align: middle;}
.table td.ok{color:green;}
.table td.fail{color:red;}
.table-form .text-center{text-align:center}

@media (max-width: 700px){.modal-dialog{padding: 0;} .modal-content{box-shadow: none;border-width: 1px 0;border-radius: 0}}
h3{font-size:16px; margin-bottom: 20px;}
blockquote{font-size:14px; padding:0px 20px; line-height:1.5; border:0}
#chanzhi{margin-top:30px}

.modal-dialog{position: relative; margin-top: 10%;}
.modal-header{position: absolute; right: 15px; top: 10px; border: none;z-index: 999}
.modal-body{padding: 20px 60px;}

.dropdown.btn{padding: 0;overflow: visible;}
.dropdown a:hover,button a:active,.dropdown a:focus{text-decoration: none;}
.dropdown .dropdown-menu li{text-align: left}
.dropdown .caret{margin-left: 8px;}
.dropdown-toggle{padding: 6px 12px; display: inline-block;}
</style>
<body>
<div class='container'>
  <div class='modal-dialog'>
    <div class='modal-content'>
      <div class="modal-header text-right">
        <div class='btn dropdown'>
          <a href='###' class='dropdown-toggle' data-toggle='dropdown'> <i class='icon-globe icon-large'></i>
            &nbsp;<?php echo $config->langs[$acceptLang]?>
            <span class='caret'></span>
          </a>
          <ul class='dropdown-menu'>
            <?php foreach($config->langs as $langCode => $langName) echo "<li><a href='?lang=$langCode'>$langName</a></li>";?>
          </ul>
        </div>
      </div>
      <div class='modal-body'>
        <h3><?php echo $clientLang->title;?></h3>
        <div>
        <div class="row">
          <div class="col-xs-6 text-center">
            <img src='?mode=getlogo' />
          </div>
          <div class="col-xs-6" style="border-left: 1px solid #ddd">
            <ul>
              <li><?php echo $clientLang->xampp;?></li>
              <li><?php echo $clientLang->official ?></li>
              <li><?php echo $clientLang->adminer ?></li>
            </ul>
          </div>
        </div>
        </div>
      </div>
    </div>
    <div class='modal-footer'>
      <p class='text-center'>
        <?php foreach($clientLang->links as $linkID => $link):?>
          <a id='product-<?php echo $linkID;?>' href="<?php echo $link['link']?>" class='btn btn-success' target='<?php echo $link['target']?>'><?php echo $clientLang->visit . $link['text'];?></a>
        <?php endforeach;?>
      </p>
    </div>
  </div>
</div>
</body>
</html>
