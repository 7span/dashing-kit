import type {ReactNode} from 'react';
import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

type FeatureItem = {
  title: string;
  Svg: React.ComponentType<React.ComponentProps<'svg'>>;
  description: ReactNode;
};

const FeatureList: FeatureItem[] = [
  {
    title: 'General Purpose',
    Svg: require('@site/static/img/front_page_image_1.svg').default,
    description: (
      <>
        A guide for both developers implementing IAP and clients managing app monetization.
      </>
    ),
  },
  {
      title: 'Built For Seamless Monetization',
      Svg: require('@site/static/img/front_page_image_2.svg').default,
      description: (
        <>
           Get to know everything about in-app purchase, best practices, common rules, and essential steps to maximize revenue.
        </>
      ),
    },
  {
    title: 'End-to-End Store Integration',
    Svg: require('@site/static/img/front_page_image_3.svg').default,
    description: (
      <>
       Learn how to configure products, subscriptions, and internal testing for both Google Play & App Store.
      </>
    ),
  },

];

function Feature({title, Svg, description}: FeatureItem) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): ReactNode {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
