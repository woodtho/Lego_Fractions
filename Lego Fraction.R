
library(brickr)
library(rgl)
library(magick)
library(tidyverse)

my_first_model <- 
  tibble::tribble(
    ~level, ~x1, ~x2, ~x3, ~x4, ~x5, ~x6, ~x7, ~x8, ~x9, ~x10, ~x11, ~x12, ~x13, ~x14, ~x15, ~x16, ~x17, ~x18, ~x19, ~x20,
    "A",  3L,  3L,  NA,  NA, 12L, 12L,  NA,  NA,  NA,   NA,   NA,   NA,   NA,   NA,   NA,  12L,  12L,   NA,   NA,   NA,
    "A",  3L,  3L,  NA,  NA, 12L, 12L,  NA,  NA,  4L,   4L,   NA,   NA,   3L,   NA,   NA,  12L,  12L,   NA,   NA,   NA,
    "A",  3L,  3L,  NA,  NA,  NA,  NA,  NA,  NA,  NA,   NA,   NA,   NA,   NA,   NA,   NA,  12L,  12L,   NA,   NA,   NA,
    "A",  3L,  3L,  NA,  NA,  NA,  NA,  NA,  NA,  NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,
    "A",  NA,  NA,  NA,  NA,  NA,  NA,  NA,  NA,  NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,
    "A",  NA,  NA,  NA,  NA,  NA,  NA,  NA,  NA,  NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,
    "A",  NA,  NA,  NA,  NA,  NA,  NA,  NA,  NA,  NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,
    "A",  NA,  NA,  NA,  NA,  NA,  NA,  NA,  NA,  NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,
    "A",  1L,  1L,  NA,  NA,  3L,  3L,  NA,  NA,  4L,   4L,   NA,   7L,   NA,   7L,   NA,   3L,   3L,   NA,  34L,  34L,
    "A",  3L,  3L,  NA,  NA,  4L,  4L,  NA,  NA,  4L,   4L,   NA,   7L,   NA,   7L,   NA,   2L,   2L,   NA,  34L,  34L,
    "A",  3L,  3L,  NA,  NA, 12L, 12L,  NA,  NA,  4L,   4L,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,
    "A",  3L,  3L,  NA,  NA,  1L,  1L,  NA,  NA,  4L,   4L,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA,   NA
  )  %>% 
  mutate(
    across(everything(), ~replace_na(.x, 0))
  )



my_first_model %>% 
  bricks_from_table() %>% 
  build_bricks()

#Rotate the default view for a better snapshot
par3d(windowRect = c(20, 30, 800, 800))
par3d(userMatrix = rotate3d(par3d("userMatrix"), pi/4, 1, 0, 0))
rgl.snapshot( ".lego.png", fmt = "png", top = TRUE )

lego <- image_read(".lego.png") %>% image_flip()  

labels_1 <- tibble::tribble(
  ~y,  ~x, ~label, 
  385, 95,    "1",
  620, 355,   "1",
  620, 95,    "+",
  620, 165,   "=",
  620, 292.5, "=",
  620, 480,   "+", 
  620, 552.5, "=",
  620, 645,   "="
)

labels_2 <- tibble::tribble(
  ~y, ~x, ~a, ~b,
  385, 230, 1, 2,
  385, 355, 1, 4,
  385, 480, 1, 8,
  380, 590, 3, 4,
  620, 70,  1, 4,  
  620, 120, 3, 4,  
  620, 230, 4, 4,
  620, 445, 1, 4,
  620, 515, 1, 4,
  620, 590, 2, 4,  
  620, 700, 1, 2,
)


arrows <- tibble::tribble(
  ~x, ~xend, ~y, ~yend,
  250, 230, 385, 270, 
  370, 355, 385, 280, 
  500, 480, 385, 275, 
  610, 590, 385, 310
  
)

lego %>% 
  image_ggplot()  +
  geom_text(data = labels_1, aes(x=x, 
                                 y=y, 
                                 label = label),
            family = "Comic Sans MS",
            size = 5) +
  geom_text(data = labels_2, aes(x=x, 
                                 y=y, 
                                 label = paste0("frac(",a, ",", b, ")")),
            parse = TRUE,
            family = "Comic Sans MS",
            size = 5) +
  geom_curve(data = arrows, 
             aes(x = x, xend = xend, y = y, yend = yend), 
             arrow = arrow(type = "closed",
                           length = unit(0.15, "inches")),
             size = 1) 
ggsave(filename = ".lego2.png",
       units = "mm")

image_read(".lego2.png") %>% 
  image_noise(noisetype = "Uniform") %>% 
  image_oilpaint() %>% 
  image_trim(fuzz = 5) %>% 
  image_border(color = "white", "50x50") %>% 
  image_write(path = "Lego Fraction.png")

file.remove(".lego.png")
file.remove(".lego2.png")

